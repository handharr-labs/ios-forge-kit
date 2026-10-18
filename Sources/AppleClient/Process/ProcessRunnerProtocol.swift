#if os(macOS)
import Foundation

/// Runs child processes. Inject this so callers can be tested with a fake.
public protocol ProcessRunnerProtocol: Sendable {
    /// Runs `executable` to completion off the caller's actor and captures its output.
    /// - Parameters:
    ///   - environment: Replaces the inherited environment when non-nil.
    ///   - timeout: Terminates the process when exceeded and sets `ProcessResult.timedOut`.
    func run(
        _ executable: URL,
        arguments: [String],
        environment: [String: String]?,
        timeout: Duration?
    ) async -> ProcessResult

    /// Starts a long-running child in its own session so it outlives the caller, and returns its pid.
    /// stdin is `/dev/null`; stdout and stderr are appended to `logFile` (or `/dev/null`).
    func spawnDetached(
        _ executable: URL,
        arguments: [String],
        environment: [String: String]?,
        logFile: URL?
    ) throws -> Int32
}

public extension ProcessRunnerProtocol {
    func run(
        _ executable: URL,
        arguments: [String],
        environment: [String: String]? = nil,
        timeout: Duration? = nil
    ) async -> ProcessResult {
        await run(executable, arguments: arguments, environment: environment, timeout: timeout)
    }

    func spawnDetached(
        _ executable: URL,
        arguments: [String],
        environment: [String: String]? = nil,
        logFile: URL?
    ) throws -> Int32 {
        try spawnDetached(executable, arguments: arguments, environment: environment, logFile: logFile)
    }
}
#endif
