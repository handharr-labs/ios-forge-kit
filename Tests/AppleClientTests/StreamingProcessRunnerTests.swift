#if os(macOS)
import XCTest
@testable import AppleClient

final class StreamingProcessRunnerTests: XCTestCase {
    private let runner = ProcessRunner()
    private let sh = URL(fileURLWithPath: "/bin/sh")

    /// Collects lines from the background thread.
    private final class Lines: @unchecked Sendable {
        private let lock = NSLock()
        private var items: [String] = []
        func add(_ line: String) { lock.withLock { items.append(line) } }
        var all: [String] { lock.withLock { items } }
    }

    func testDeliversEachLineInOrderAndReturnsTheWholeOutput() async {
        let lines = Lines()
        let r = await runner.runStreaming(sh, arguments: ["-c", "echo one; echo two; echo three"], environment: nil,
                                          currentDirectory: nil, timeout: nil, onOutput: lines.add)
        XCTAssertEqual(lines.all, ["one", "two", "three"])
        XCTAssertEqual(r.stdout, "one\ntwo\nthree\n")
        XCTAssertEqual(r.stderr, "")
        XCTAssertTrue(r.succeeded)
    }

    func testStdoutAndStderrShareOneOrderedStream() async {
        let lines = Lines()
        _ = await runner.runStreaming(sh, arguments: ["-c", "echo out1; echo err1 1>&2; echo out2"], environment: nil,
                                      currentDirectory: nil, timeout: nil, onOutput: lines.add)
        XCTAssertEqual(lines.all, ["out1", "err1", "out2"])
    }

    func testAFinalLineWithoutALineBreakIsDelivered() async {
        let lines = Lines()
        _ = await runner.runStreaming(sh, arguments: ["-c", "printf 'a\\nb'"], environment: nil,
                                      currentDirectory: nil, timeout: nil, onOutput: lines.add)
        XCTAssertEqual(lines.all, ["a", "b"])
    }

    func testOutputArrivesWhileTheChildIsStillRunning() async {
        let first = expectation(description: "first line while running")
        let started = Date()
        let runner = runner, sh = sh
        let task = Task {
            await runner.runStreaming(sh, arguments: ["-c", "echo early; sleep 2; echo late"], environment: nil,
                                      currentDirectory: nil, timeout: nil) { line in
                if line == "early" { first.fulfill() }
            }
        }
        await fulfillment(of: [first], timeout: 1.5)
        XCTAssertLessThan(Date().timeIntervalSince(started), 1.5)
        _ = await task.value
    }

    func testRunsInTheGivenDirectoryAndPassesTheEnvironment() async throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent("stream-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: dir) }
        let r = await runner.runStreaming(
            sh, arguments: ["-c", "pwd -P; printf %s \"$PR_STREAM\""], environment: ["PR_STREAM": "ok", "PATH": "/usr/bin:/bin"],
            currentDirectory: dir, timeout: nil, onOutput: { _ in })
        var buffer = [CChar](repeating: 0, count: Int(PATH_MAX))
        XCTAssertNotNil(realpath(dir.path, &buffer))
        XCTAssertEqual(r.stdout, "\(String(cString: buffer))\nok")
    }

    func testTimeoutTerminatesTheChildAndItsChildren() async {
        let start = Date()
        let r = await runner.runStreaming(sh, arguments: ["-c", "sleep 30 & sleep 30"], environment: nil,
                                          currentDirectory: nil, timeout: .milliseconds(300), onOutput: { _ in })
        XCTAssertTrue(r.timedOut)
        XCTAssertLessThan(Date().timeIntervalSince(start), 3)
    }

    func testCancellingTheTaskTerminatesTheChild() async {
        let start = Date()
        let runner = runner, sh = sh
        let task = Task {
            await runner.runStreaming(sh, arguments: ["-c", "sleep 30 & sleep 30"], environment: nil,
                                      currentDirectory: nil, timeout: nil, onOutput: { _ in })
        }
        try? await Task.sleep(for: .milliseconds(300))
        task.cancel()
        let r = await task.value
        XCTAssertFalse(r.succeeded)
        XCTAssertLessThan(Date().timeIntervalSince(start), 3)
    }

    func testCancelledBeforeItStartsNeverRuns() async {
        let runner = runner, sh = sh
        let task = Task {
            await runner.runStreaming(sh, arguments: ["-c", "echo hi"], environment: nil, currentDirectory: nil,
                                      timeout: nil, onOutput: { _ in })
        }
        task.cancel()
        let r = await task.value
        // Either it was cancelled before it started (-1) or it won the race and finished; never a hang.
        XCTAssertTrue(r.status == -1 || r.stdout == "hi\n")
    }

    func testMissingExecutableFailsGracefully() async {
        let r = await runner.runStreaming(URL(fileURLWithPath: "/nonexistent/tool"), arguments: [], environment: nil,
                                          currentDirectory: nil, timeout: nil, onOutput: { _ in })
        XCTAssertEqual(r.status, -1)
        XCTAssertFalse(r.succeeded)
    }
}
#endif
