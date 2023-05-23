import Foundation

struct LinksResponse: Codable {
    let entityUniqueId: String
    let userCountry: String
    let pageUrl: String
    let entitiesByUniqueId: [String: EntitiesByUniqueID]
    let linksByPlatform: [String: PlatformLinks]
    
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
    
    /// Returns an array of URLs for available platform thumbnails.
    var thumbnailUrls: [URL] {
        var urls = [URL]()
        for entity in entitiesByUniqueId.values {
            if let thumbnailUrl = entity.thumbnailUrl {
                urls.append(thumbnailUrl)
            }
        }
        return urls
    }

    /// Returns the capitalized names of the available platforms.
    var availablePlatformTitles: [String] {
        return linksByPlatform.keys.sorted().map { $0.capitalized }
    }
    
    /// An array of available platform URLs cleaned from query parameters.
    var availablePlatformUrls: [URL] {
        var urls = [URL]()
        for platformLink in linksByPlatform.values {
            if var urlComponents = URLComponents(string: platformLink.url) {
                urlComponents.query = nil
                if let cleanURL = urlComponents.url {
                    urls.append(cleanURL)
                }
            }
        }
        return urls
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

struct PlatformLinks: Codable {
    let country: String
    let url: String
    let nativeAppUriMobile: String?
    let nativeAppUriDesktop: String?
    let entityUniqueId: String
}
