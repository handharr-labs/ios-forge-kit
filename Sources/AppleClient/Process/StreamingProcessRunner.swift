#if os(macOS)
import Darwin
import Foundation

/// A runner that can also deliver a child's output while it runs, start it in a chosen folder, and stop
/// it (and its children) when the calling task is cancelled. Inject this so callers can be tested with a fake.
public protocol StreamingProcessRunnerProtocol: ProcessRunnerProtocol {
    /// Runs `executable` to completion off the caller's actor.
    ///
    /// stdout and stderr share one pipe, so `onOutput` receives their lines in the order the child wrote
    /// them, one call per line (without the line break), and `ProcessResult.stdout` holds everything the child
    /// printed (`stderr` is empty). Cancelling the calling task, or exceeding `timeout`, terminates the child and
    /// everything it started; a child that ignores SIGTERM is killed one second later.
    /// - Parameters:
    ///   - environment: Replaces the inherited environment when non-nil.
    ///   - currentDirectory: The child's working folder; the caller's when nil.
    ///   - onOutput: Called from a background thread, in order.
    func runStreaming(
        _ executable: URL,
        arguments: [String],
        environment: [String: String]?,
        currentDirectory: URL?,
        timeout: Duration?,
        onOutput: @escaping @Sendable (String) -> Void
    ) async -> ProcessResult
}

extension ProcessRunner: StreamingProcessRunnerProtocol {
    public func runStreaming(
        _ executable: URL,
        arguments: [String],
        environment: [String: String]?,
        currentDirectory: URL?,
        timeout: Duration?,
        onOutput: @escaping @Sendable (String) -> Void
    ) async -> ProcessResult {
        let child = StreamingChild()
        return await withTaskCancellationHandler {
            await withCheckedContinuation { cont in
                DispatchQueue.global(qos: .utility).async {
                    cont.resume(returning: Self.streamSync(
                        executable, arguments, environment, currentDirectory, timeout, child, onOutput))
                }
            }
        } onCancel: {
            child.cancel()
        }
    }

    private static func streamSync(
        _ executable: URL, _ arguments: [String], _ environment: [String: String]?, _ directory: URL?,
        _ timeout: Duration?, _ child: StreamingChild, _ onOutput: @escaping @Sendable (String) -> Void
    ) -> ProcessResult {
        let p = Process()
        p.executableURL = executable
        p.arguments = arguments
        if let environment { p.environment = environment }
        if let directory { p.currentDirectoryURL = directory }
        let pipe = Pipe()
        p.standardOutput = pipe
        p.standardError = pipe
        p.standardInput = FileHandle.nullDevice
        guard child.attach(p) else { return ProcessResult(status: -1, stderr: "cancelled before it started") }
        do { try p.run() } catch {
            return ProcessResult(status: -1, stderr: error.localizedDescription)
        }
        // The write end belongs to the child now; closing ours lets the read below see the end of the output.
        try? pipe.fileHandleForWriting.close()
        child.started()

        var watchdog: DispatchWorkItem?
        if let timeout {
            let item = DispatchWorkItem { child.timeOut() }
            watchdog = item
            DispatchQueue.global().asyncAfter(deadline: .now() + seconds(timeout), execute: item)
        }

        var all = Data()
        var pending = Data()
        let newline = UInt8(ascii: "\n")
        while true {
            let chunk = pipe.fileHandleForReading.availableData
            if chunk.isEmpty { break }
            all.append(chunk)
            pending.append(chunk)
            while let end = pending.firstIndex(of: newline) {
                emit(pending[pending.startIndex..<end], onOutput)
                pending.removeSubrange(pending.startIndex...end)
            }
        }
        if !pending.isEmpty { emit(pending[...], onOutput) }
        p.waitUntilExit()
        watchdog?.cancel()
        return ProcessResult(
            status: p.terminationStatus, stdout: String(decoding: all, as: UTF8.self), stderr: "",
            timedOut: child.didTimeOut)
    }

    private static func emit(_ bytes: Data.SubSequence, _ onOutput: @Sendable (String) -> Void) {
        var line = bytes
        if line.last == UInt8(ascii: "\r") { line = line.dropLast() }
        onOutput(String(decoding: line, as: UTF8.self))
    }

    private static func seconds(_ d: Duration) -> Double {
        let c = d.components
        return Double(c.seconds) + Double(c.attoseconds) / 1e18
    }
}

/// The running child of one `runStreaming` call, shared with its cancellation handler.
private final class StreamingChild: @unchecked Sendable {
    private let lock = NSLock()
    private var process: Process?
    private var cancelled = false
    private var timedOut = false

    var didTimeOut: Bool { lock.withLock { timedOut } }

    /// Remembers the process; false when the call was cancelled before it could start.
    func attach(_ p: Process) -> Bool {
        lock.withLock {
            guard !cancelled else { return false }
            process = p
            return true
        }
    }

    /// The process is running: a cancellation that arrived in between is applied now.
    func started() {
        let stopNow = lock.withLock { cancelled }
        if stopNow { terminateTree() }
    }

    func cancel() {
        lock.withLock { cancelled = true }
        terminateTree()
    }

    func timeOut() {
        lock.withLock { timedOut = true }
        terminateTree()
    }

    private func terminateTree() {
        guard let p = lock.withLock({ process }), p.isRunning else { return }
        let pid = p.processIdentifier
        let victims = Self.descendants(of: pid) + [pid]
        for victim in victims { kill(victim, SIGTERM) }
        // Anything that ignores SIGTERM is killed one second later.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            for victim in victims where kill(victim, 0) == 0 { kill(victim, SIGKILL) }
        }
    }

    /// Every process below `pid`, children before their own children.
    static func descendants(of pid: Int32) -> [Int32] {
        var found: [Int32] = []
        var queue = [pid]
        while let current = queue.popLast() {
            // Room for 1024 children; the buffer starts at zero, and a zero entry is not a pid.
            var buffer = [Int32](repeating: 0, count: 1024)
            let bytes = Int32(buffer.count * MemoryLayout<Int32>.size)
            guard proc_listchildpids(current, &buffer, bytes) > 0 else { continue }
            let children = buffer.filter { $0 > 0 }
            found.append(contentsOf: children)
            queue.append(contentsOf: children)
        }
        return found
    }
}
#endif
