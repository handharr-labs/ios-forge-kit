#if os(macOS)
import Foundation

/// A point-in-time reading of one running process.
public struct ProcessSnapshot: Sendable, Equatable {
    public var pid: Int32
    public var parentPID: Int32
    /// The executable's path (`proc_pidpath`); nil when it cannot be read.
    public var executablePath: String?
    /// argv, as the process was started (parsed from `KERN_PROCARGS2`); empty when it cannot be read.
    public var arguments: [String]
    /// User plus system CPU time the process has used so far, in wall-clock units.
    public var cpuTime: Duration
    /// `ri_phys_footprint`: the figure Activity Monitor's Memory column shows.
    public var physicalFootprint: UInt64

    public init(pid: Int32, parentPID: Int32, executablePath: String? = nil, arguments: [String] = [],
                cpuTime: Duration = .zero, physicalFootprint: UInt64 = 0) {
        self.pid = pid
        self.parentPID = parentPID
        self.executablePath = executablePath
        self.arguments = arguments
        self.cpuTime = cpuTime
        self.physicalFootprint = physicalFootprint
    }
}
#endif
