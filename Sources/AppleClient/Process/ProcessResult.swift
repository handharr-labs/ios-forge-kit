#if os(macOS)
import Foundation

/// The outcome of a finished child process.
public struct ProcessResult: Sendable, Equatable {
    /// Exit status, or `-1` when the process could not be launched.
    public var status: Int32
    public var stdout: String
    public var stderr: String
    /// `true` when the runner terminated the process because it exceeded its timeout.
    public var timedOut: Bool

    public init(status: Int32, stdout: String = "", stderr: String = "", timedOut: Bool = false) {
        self.status = status
        self.stdout = stdout
        self.stderr = stderr
        self.timedOut = timedOut
    }

    /// Exited with status 0 and was not terminated for timing out.
    public var succeeded: Bool { status == 0 && !timedOut }
}
#endif
