#if os(macOS)
import Darwin
import Foundation

/// Lists the running processes. Inject this so callers can be tested with a fake.
public protocol ProcessInspectorProtocol: Sendable {
    /// Every process this user can read. Processes that cannot be read (other users', or that exited
    /// meanwhile) are left out.
    func snapshot() -> [ProcessSnapshot]
}

/// Reads processes with `libproc` and `sysctl`. Read-only.
public struct ProcessInspector: ProcessInspectorProtocol {
    public init() {}

    public func snapshot() -> [ProcessSnapshot] {
        let capacity = Int(proc_listallpids(nil, 0))
        guard capacity > 0 else { return [] }
        // Room for processes that start between the two calls.
        var pids = [Int32](repeating: 0, count: capacity + 64)
        // `proc_listallpids` returns the number of pids it wrote (not bytes, despite the buffer size argument).
        let count = pids.withUnsafeMutableBytes { proc_listallpids($0.baseAddress, Int32($0.count)) }
        guard count > 0 else { return [] }
        let timebase = Self.timebase()
        return pids.prefix(Int(count)).compactMap { pid in
            pid > 0 ? Self.read(pid: pid, timebase: timebase) : nil
        }
    }

    /// One process, or nil when its parent, CPU time or memory cannot be read.
    static func read(pid: Int32, timebase: mach_timebase_info) -> ProcessSnapshot? {
        var bsd = proc_bsdinfo()
        let size = Int32(MemoryLayout<proc_bsdinfo>.size)
        guard proc_pidinfo(pid, PROC_PIDTBSDINFO, 0, &bsd, size) == size else { return nil }

        var usage = rusage_info_v2()
        let status = withUnsafeMutablePointer(to: &usage) {
            $0.withMemoryRebound(to: rusage_info_t?.self, capacity: 1) { proc_pid_rusage(pid, RUSAGE_INFO_V2, $0) }
        }
        guard status == 0 else { return nil }

        // `ri_user_time` and `ri_system_time` are Mach absolute time units, which are not nanoseconds on
        // Apple Silicon.
        let nanoseconds = Self.nanoseconds(fromMachTime: usage.ri_user_time &+ usage.ri_system_time, timebase: timebase)
        return ProcessSnapshot(
            pid: pid, parentPID: Int32(bsd.pbi_ppid), executablePath: path(pid: pid), arguments: arguments(pid: pid),
            cpuTime: .nanoseconds(Int64(clamping: nanoseconds)), physicalFootprint: usage.ri_phys_footprint)
    }

    static func timebase() -> mach_timebase_info {
        var info = mach_timebase_info()
        mach_timebase_info(&info)
        return info.denom == 0 ? mach_timebase_info(numer: 1, denom: 1) : info
    }

    /// Mach absolute time to nanoseconds, split so a large tick count cannot overflow.
    static func nanoseconds(fromMachTime ticks: UInt64, timebase: mach_timebase_info) -> UInt64 {
        let numer = UInt64(timebase.numer), denom = UInt64(timebase.denom)
        return (ticks / denom) * numer + (ticks % denom) * numer / denom
    }

    static func path(pid: Int32) -> String? {
        var buffer = [CChar](repeating: 0, count: 4 * Int(MAXPATHLEN))
        let length = proc_pidpath(pid, &buffer, UInt32(buffer.count))
        guard length > 0 else { return nil }
        return String(decoding: buffer.prefix(Int(length)).map { UInt8(bitPattern: $0) }, as: UTF8.self)
    }

    static func arguments(pid: Int32) -> [String] {
        var mib: [Int32] = [CTL_KERN, KERN_PROCARGS2, pid]
        var length = 0
        guard sysctl(&mib, UInt32(mib.count), nil, &length, nil, 0) == 0, length > 0 else { return [] }
        var buffer = [UInt8](repeating: 0, count: length)
        guard sysctl(&mib, UInt32(mib.count), &buffer, &length, nil, 0) == 0 else { return [] }
        return parseProcArgs(Array(buffer.prefix(length)))
    }

    /// `KERN_PROCARGS2` layout: Int32 argc, the executable path, NUL padding, then argc NUL-terminated
    /// arguments (the environment follows and is ignored).
    static func parseProcArgs(_ raw: [UInt8]) -> [String] {
        guard raw.count > MemoryLayout<Int32>.size else { return [] }
        let argc = raw.withUnsafeBytes { Int($0.loadUnaligned(as: Int32.self)) }
        var i = MemoryLayout<Int32>.size
        while i < raw.count, raw[i] != 0 { i += 1 }   // executable path
        while i < raw.count, raw[i] == 0 { i += 1 }   // padding
        var result: [String] = []
        while result.count < argc, i < raw.count {
            var end = i
            while end < raw.count, raw[end] != 0 { end += 1 }
            result.append(String(decoding: raw[i..<end], as: UTF8.self))
            i = end + 1
        }
        return result
    }
}
#endif
