import Foundation
import Core

typealias FetchBasketRequest = Request<Void, FetchBasketPath>

struct FetchBasketPath: Sendable, Equatable {
    let basketID: Int
}
