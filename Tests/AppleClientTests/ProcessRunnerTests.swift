#if os(macOS)
import XCTest
@testable import AppleClient

final class ProcessRunnerTests: XCTestCase {
    private let runner = ProcessRunner()
    private let sh = URL(fileURLWithPath: "/bin/sh")

    func testCapturesStdout() async {
        let r = await runner.run(URL(fileURLWithPath: "/bin/echo"), arguments: ["hello"])
        XCTAssertEqual(r.status, 0)
        XCTAssertEqual(r.stdout, "hello\n")
        XCTAssertTrue(r.succeeded)
        XCTAssertFalse(r.timedOut)
    }

    func testNonZeroExitIsReported() async {
        let r = await runner.run(sh, arguments: ["-c", "exit 3"])
        XCTAssertEqual(r.status, 3)
        XCTAssertFalse(r.succeeded)
    }

    func testCapturesStderrSeparately() async {
        let r = await runner.run(sh, arguments: ["-c", "echo out; echo err 1>&2"])
        XCTAssertEqual(r.stdout, "out\n")
        XCTAssertEqual(r.stderr, "err\n")
    }

    func testLargeOutputOnBothPipesDoesNotDeadlock() async {
        let script = "yes 0123456789abcdef | head -c 2000000; yes fedcba9876543210 | head -c 2000000 1>&2"
        let r = await runner.run(sh, arguments: ["-c", script], timeout: .seconds(30))
        XCTAssertFalse(r.timedOut)
        XCTAssertEqual(r.status, 0)
        XCTAssertEqual(r.stdout.utf8.count, 2_000_000)
        XCTAssertEqual(r.stderr.utf8.count, 2_000_000)
    }

    func testTimeoutKillsTheProcess() async {
        let start = Date()
        let r = await runner.run(URL(fileURLWithPath: "/bin/sleep"), arguments: ["5"], timeout: .milliseconds(300))
        XCTAssertTrue(r.timedOut)
        XCTAssertFalse(r.succeeded)
        XCTAssertLessThan(Date().timeIntervalSince(start), 1.5)
    }

    func testFinishingBeforeTheTimeoutIsNotTimedOut() async {
        let r = await runner.run(URL(fileURLWithPath: "/bin/echo"), arguments: ["x"], timeout: .seconds(5))
        XCTAssertFalse(r.timedOut)
        XCTAssertTrue(r.succeeded)
    }

    func testEnvironmentIsPassedThrough() async {
        let r = await runner.run(sh, arguments: ["-c", "printf %s \"$PR_TEST_VALUE\""],
                                 environment: ["PR_TEST_VALUE": "forty-two", "PATH": "/usr/bin:/bin"])
        XCTAssertEqual(r.stdout, "forty-two")
    }

    func testMissingExecutableFailsGracefully() async {
        let r = await runner.run(URL(fileURLWithPath: "/nonexistent/tool"), arguments: [])
        XCTAssertEqual(r.status, -1)
        XCTAssertFalse(r.stderr.isEmpty)
        XCTAssertFalse(r.succeeded)
    }

    // MARK: spawnDetached

    func testSpawnDetachedRunsInItsOwnSessionAndLogs() throws {
        let log = FileManager.default.temporaryDirectory.appendingPathComponent("process-runner-\(UUID().uuidString).log")
        defer { try? FileManager.default.removeItem(at: log) }

        let pid = try runner.spawnDetached(sh, arguments: ["-c", "echo hi; sleep 1"], logFile: log)

        XCTAssertGreaterThan(pid, 0)
        XCTAssertEqual(kill(pid, 0), 0, "the child is alive right after the call")
        XCTAssertNotEqual(getsid(pid), getsid(0), "the child has its own session")

        let deadline = Date().addingTimeInterval(5)
        var contents = ""
        while Date() < deadline {
            contents = (try? String(contentsOf: log, encoding: .utf8)) ?? ""
            if contents.contains("hi"), kill(pid, 0) != 0 { break }
            Thread.sleep(forTimeInterval: 0.05)
        }
        XCTAssertTrue(contents.contains("hi"))
        XCTAssertNotEqual(kill(pid, 0), 0, "the child has exited and been reaped")
    }

    func testSpawnDetachedWithoutLogFileDiscardsOutput() throws {
        let pid = try runner.spawnDetached(URL(fileURLWithPath: "/bin/echo"), arguments: ["x"], logFile: nil)
        XCTAssertGreaterThan(pid, 0)
    }

    func testSpawnDetachedMissingExecutableThrows() {
        XCTAssertThrowsError(try runner.spawnDetached(URL(fileURLWithPath: "/nonexistent/tool"), arguments: [], logFile: nil)) {
            guard case ProcessRunnerError.spawnFailed(let path, _) = $0 else { return XCTFail("wrong error \($0)") }
            XCTAssertEqual(path, "/nonexistent/tool")
        }
    }
}
#endif
