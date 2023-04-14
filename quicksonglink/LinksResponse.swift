import Foundation

struct LinksResponse: Codable {
    let entityUniqueId: String
    let pageUrl: String
    let entitiesByUniqueId: [String: EntitiesByUniqueID]

    var artist: String {
        entitiesByUniqueId.first.map(\.value.artistName) ?? ""
    }

    var title: String {
        entitiesByUniqueId.first.map(\.value.title) ?? ""
    }

    var type: TypeEnum {
        entitiesByUniqueId.first.map(\.value.type) ?? .song
    }

    var thumbnailURL: URL? {
        entitiesByUniqueId.first.flatMap(\.value.thumbnailUrl)
    }

    var nonLocalPageURL: String {
        pageUrl.replacingOccurrences(of: "/fi", with: "")
    }

    static var mock: LinksResponse {
        LinksResponse(
            entityUniqueId: "ITUNES_ALBUM::1480004024",
            pageUrl: "https://album.link/fi/i/1480004024",
            entitiesByUniqueId: [
                "AMAZON_ALBUM::B07XVDV2MZ": EntitiesByUniqueID(
                    id: "B07XVDV2MZ",
                    type: .album,
                    title: "here's the drop!",
                    artistName: "deadmau5",
                    thumbnailUrl: URL(string: "https://m.media-amazon.com/images/I/51UM91aHFWL.jpg"),
                    thumbnailWidth: 500,
                    thumbnailHeight: 500,
                    apiProvider: "amazon",
                    platforms: ["amazonMusic", "amazonStore"]
                )
            ]
        )
    }
}

struct EntitiesByUniqueID: Codable {
    let id: String?
    let type: TypeEnum
    let title: String
    let artistName: String
    let thumbnailUrl: URL?
    let thumbnailWidth, thumbnailHeight: Int?
    let apiProvider: String?
    let platforms: [String]?
}

enum TypeEnum: String, Codable {
    case song, album

    var icon: String {
        switch self {
        case .song:
            return "music.note"
        case .album:
            return "rectangle.stack"
        }
    }
}
