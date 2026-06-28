import Foundation
import Core

typealias FetchDishesRequest = Request<Void, FetchDishesPath>

struct FetchDishesPath: Sendable, Equatable {
    let restaurantID: Int
}
