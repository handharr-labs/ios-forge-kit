import Foundation

struct CreatePlaylistRequest: Encodable {
    let name: String
    let description: String
    let trackIds: [Int]

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case trackIds = "track_ids"
    }
}
