import Foundation
import Core

struct FetchHotelDetailPath: Sendable, Equatable {
    let hotelId: String
}

typealias FetchHotelDetailRequest = Request<Void, FetchHotelDetailPath>
