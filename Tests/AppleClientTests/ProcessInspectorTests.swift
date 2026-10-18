#if os(macOS)
import Darwin
import XCTest
@testable import AppleClient

final class ProcessInspectorTests: XCTestCase {
    private let inspector = ProcessInspector()

    private func me() throws -> ProcessSnapshot {
        try XCTUnwrap(inspector.snapshot().first { $0.pid == getpid() }, "the test process is listed")
    }

    func testSnapshotContainsThisProcess() throws {
        let mine = try me()
        XCTAssertEqual(mine.parentPID, getppid())
        XCTAssertFalse(try XCTUnwrap(mine.executablePath).isEmpty)
        XCTAssertEqual(mine.arguments.count, CommandLine.arguments.count)
        XCTAssertEqual(mine.arguments.first, CommandLine.arguments.first)
        XCTAssertGreaterThan(mine.physicalFootprint, 0)
    }

    func testCPUTimeIsInRealTimeUnits() throws {
        func seconds(_ d: Duration) -> Double {
            Double(d.components.seconds) + Double(d.components.attoseconds) / 1e18
        }
        let before = seconds(try me().cpuTime)
        let start = ContinuousClock.now
        var x = 0.0
        while ContinuousClock.now - start < .milliseconds(200) { x += sin(x + 1) }   // busy, on this thread
        XCTAssertFalse(x.isNaN)
        let grew = seconds(try me().cpuTime) - before
        // About 0.2 s of CPU. A units mistake would be off by 41x (Apple Silicon) or never match at all.
        XCTAssertGreaterThan(grew, 0.15)
        XCTAssertLessThan(grew, 0.6)
    }

    func testMachTimeConversion() {
        let t = mach_timebase_info(numer: 125, denom: 3)
        XCTAssertEqual(ProcessInspector.nanoseconds(fromMachTime: 3_000, timebase: t), 125_000)
        XCTAssertEqual(ProcessInspector.nanoseconds(fromMachTime: 1, timebase: t), 41)
        XCTAssertEqual(ProcessInspector.nanoseconds(fromMachTime: UInt64.max / 200, timebase: t) > 0, true)
    }

    func testParsesProcArgs() {
        var raw = [UInt8](withUnsafeBytes(of: Int32(2)) { Array($0) })
        raw += Array("/bin/tool".utf8) + [0, 0, 0]
        raw += Array("tool".utf8) + [0] + Array("-x y".utf8) + [0]
        raw += Array("HOME=/h".utf8) + [0]
        XCTAssertEqual(ProcessInspector.parseProcArgs(raw), ["tool", "-x y"])
        XCTAssertEqual(ProcessInspector.parseProcArgs([]), [])
    }

    func testListsEveryProcessOfThisUser() throws {
        let ps = Process()
        ps.executableURL = URL(fileURLWithPath: "/bin/ps")
        ps.arguments = ["-x", "-o", "pid="]
        let out = Pipe()
        ps.standardOutput = out
        try ps.run()
        let data = out.fileHandleForReading.readDataToEndOfFile()
        ps.waitUntilExit()
        let expected = String(decoding: data, as: UTF8.self).split(whereSeparator: \.isNewline)
            .compactMap { Int32($0.trimmingCharacters(in: .whitespaces)) }
        let listed = Set(inspector.snapshot().map(\.pid))
        let missing = expected.filter { !listed.contains($0) }
        // A few may have exited between the two reads (ps itself is one).
        XCTAssertGreaterThan(expected.count, 10)
        XCTAssertLessThanOrEqual(missing.count, 3, "missing pids: \(missing)")
    }

    func testChildStartedByTheRunnerAppearsWithItsArguments() throws {
        let runner: any ProcessRunnerProtocol = ProcessRunner()
        let pid = try runner.spawnDetached(URL(fileURLWithPath: "/bin/sleep"), arguments: ["2"], logFile: nil)
        defer { kill(pid, SIGTERM) }
        let child = try XCTUnwrap(inspector.snapshot().first { $0.pid == pid })
        XCTAssertEqual(child.arguments, ["/bin/sleep", "2"])
        XCTAssertEqual(child.executablePath, "/bin/sleep")
    }
}
#endif
