import Foundation
@testable import Melodify

final class MockAPIClient: APIClientProtocol {
    var getStub: Any?
    var postStub: Any?
    var putStub: Any?
    var shouldThrow: Error?

    private(set) var lastGetURL: URL?
    private(set) var lastPostURL: URL?
    private(set) var lastPutURL: URL?

    func get<T: Decodable>(_ url: URL) async throws -> T {
        lastGetURL = url
        if let error = shouldThrow { throw error }
        return getStub as! T
    }

    func post<Body: Encodable, T: Decodable>(_ url: URL, body: Body) async throws -> T {
        lastPostURL = url
        if let error = shouldThrow { throw error }
        return postStub as! T
    }

    func put<Body: Encodable, T: Decodable>(_ url: URL, body: Body) async throws -> T {
        lastPutURL = url
        if let error = shouldThrow { throw error }
        return putStub as! T
    }

    func patch<Body: Encodable, T: Decodable>(_ url: URL, body: Body) async throws -> T {
        if let error = shouldThrow { throw error }
        return putStub as! T
    }

    func delete<T: Decodable>(_ url: URL) async throws -> T {
        if let error = shouldThrow { throw error }
        return getStub as! T
    }
}
