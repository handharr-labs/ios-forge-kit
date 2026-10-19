#if os(macOS)
import Foundation

/// Why `spawnDetached` could not start the child.
public enum ProcessRunnerError: Error, Equatable, LocalizedError, Sendable {
    /// `posix_spawn` failed; `code` is the errno it returned.
    case spawnFailed(path: String, code: Int32)
    /// The log file could not be prepared for appending.
    case logFileUnavailable(String)

    public var errorDescription: String? {
        switch self {
        case .spawnFailed(let path, let code):
            "Could not start \(path): \(String(cString: strerror(code)))"
        case .logFileUnavailable(let message):
            "Could not open the log file: \(message)"
        }
    }
}

/// The real `ProcessRunnerProtocol`, backed by `Foundation.Process` and `posix_spawn`.
public struct ProcessRunner: ProcessRunnerProtocol {
    public init() {}

    // MARK: run

    public func run(
        _ executable: URL,
        arguments: [String],
        environment: [String: String]?,
        timeout: Duration?
    ) async -> ProcessResult {
        await withCheckedContinuation { cont in
            DispatchQueue.global(qos: .utility).async {
                cont.resume(returning: Self.runSync(executable, arguments, environment, timeout))
            }
        }
    }

    private final class TimeoutFlag: @unchecked Sendable {
        private let lock = NSLock()
        private var value = false
        func set() { lock.lock(); value = true; lock.unlock() }
        var isSet: Bool { lock.lock(); defer { lock.unlock() }; return value }
    }

    private final class DataBox: @unchecked Sendable {
        var data = Data()
    }

    private static func runSync(
        _ executable: URL, _ arguments: [String], _ environment: [String: String]?, _ timeout: Duration?
    ) -> ProcessResult {
        let p = Process()
        p.executableURL = executable
        p.arguments = arguments
        if let environment { p.environment = environment }
        let out = Pipe(), err = Pipe()
        p.standardOutput = out
        p.standardError = err
        p.standardInput = FileHandle.nullDevice
        do { try p.run() } catch {
            return ProcessResult(status: -1, stderr: error.localizedDescription)
        }

        let flag = TimeoutFlag()
        var watchdog: DispatchWorkItem?
        if let timeout {
            let item = DispatchWorkItem { [p] in
                guard p.isRunning else { return }
                flag.set()
                p.terminate()
                // A process that ignores SIGTERM is killed one second later.
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    if p.isRunning { kill(p.processIdentifier, SIGKILL) }
                }
            }
            watchdog = item
            DispatchQueue.global().asyncAfter(deadline: .now() + seconds(timeout), execute: item)
        }

        // stderr is drained on its own thread so a full pipe can't deadlock us. A dedicated thread, not the
        // global queue: with many runs at once every pool thread can be waiting here, and a drain queued on
        // the same pool would then never start.
        let errBox = DataBox()
        let drained = DispatchSemaphore(value: 0)
        let drain = Thread {
            errBox.data = err.fileHandleForReading.readDataToEndOfFile()
            drained.signal()
        }
        drain.start()
        let outData = out.fileHandleForReading.readDataToEndOfFile()
        drained.wait()
        p.waitUntilExit()
        watchdog?.cancel()
        return ProcessResult(
            status: p.terminationStatus,
            stdout: String(decoding: outData, as: UTF8.self),
            stderr: String(decoding: errBox.data, as: UTF8.self),
            timedOut: flag.isSet)
    }

    private static func seconds(_ d: Duration) -> Double {
        let c = d.components
        return Double(c.seconds) + Double(c.attoseconds) / 1e18
    }

    // MARK: spawnDetached

    public func spawnDetached(
        _ executable: URL,
        arguments: [String],
        environment: [String: String]?,
        logFile: URL?
    ) throws -> Int32 {
        let path = executable.path
        var actions: posix_spawn_file_actions_t?
        posix_spawn_file_actions_init(&actions)
        defer { posix_spawn_file_actions_destroy(&actions) }
        posix_spawn_file_actions_addopen(&actions, 0, "/dev/null", O_RDONLY, 0)
        posix_spawn_file_actions_addopen(&actions, 1, logFile?.path ?? "/dev/null", O_WRONLY | O_CREAT | O_APPEND, 0o644)
        posix_spawn_file_actions_adddup2(&actions, 1, 2)

        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        defer { posix_spawnattr_destroy(&attr) }
        // Own session: the child survives the caller quitting and never receives its terminal signals.
        posix_spawnattr_setflags(&attr, Int16(POSIX_SPAWN_SETSID))

        let argv = ([path] + arguments).map { strdup($0) } + [nil]
        let env = (environment ?? ProcessInfo.processInfo.environment).map { strdup("\($0.key)=\($0.value)") } + [nil]
        defer {
            argv.forEach { free($0) }
            env.forEach { free($0) }
        }

        var pid: pid_t = 0
        let code = posix_spawn(&pid, path, &actions, &attr, argv, env)
        guard code == 0 else { throw ProcessRunnerError.spawnFailed(path: path, code: code) }
        // Reap the child when it exits so it never lingers as a zombie.
        let child = pid
        DispatchQueue.global(qos: .utility).async {
            var status: Int32 = 0
            while waitpid(child, &status, 0) == -1 && errno == EINTR {}
        }
        return pid
    }
}
#endif
