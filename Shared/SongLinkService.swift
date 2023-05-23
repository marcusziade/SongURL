import Foundation

final class SongLinkService {

    static var mockLinks: LinksResponse {
        let mock: LinksResponse = try! SongLinkService().getMockData(forFileName: "songlink_mock", filetype: "json")
        return mock
    }
    
    func songLink(for link: String) async throws -> LinksResponse {
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "url", value: link)]
        components.scheme = "https"
        components.host = "api.song.link"
        components.path = "/v1-alpha.1/links"
        guard let url = components.url else {
            throw HTTPError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPError.badResponse
        }

        switch httpResponse.statusCode {
        case 100...199:
            throw HTTPError.information

        case 200...299:
            do {
                return try JSONDecoder().decode(LinksResponse.self, from: data)
            } catch {
                throw error
            }

        case 300...399:
            throw HTTPError.redirected

        case 400...499:
            throw HTTPError.badResponse

        case 500...599:
            throw HTTPError.serverError

        default:
            throw HTTPError.unknownError
        }
    }

    func getMockData<T: Codable>(forFileName fileName: String, filetype: String) throws -> T {
        guard let path = Bundle.main.path(forResource: fileName, ofType: filetype) else {
            throw MockError.path
        }
        
        let url = URL(fileURLWithPath: path)
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw MockError.data
        }
        
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw MockError.decode
        }
    }
    
    // MARK: Private
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
}

enum MockError: Error {
    case path, data, decode

    var description: String {
        switch self {
        case .path:
            return "Path not found"
        case .data:
            return "Failed to create data from URL"
        case .decode:
            return "Failed to decode mock data"
        }
    }
}

enum HTTPError: Error {
    case information
    case badData
    case badResponse
    case invalidStatusCode
    case redirected
    case serverError
    case unknownError
    case decodingError
    case badURL

    var description: String {
        switch self {
        case .information: return "❌ Bad information response"
        case .badData: return "❌ Bad data response"
        case .badResponse: return "❌ Bad response. Check your link for errors."
        case .invalidStatusCode: return "❌ Invalid statuc code response"
        case .redirected: return "❌ Redirection reponse"
        case .serverError: return "❌ Server error"
        case .unknownError: return "❌ Unknown error"
        case .decodingError: return "❌ Decoding error"
        case .badURL: return "❌ Bad URL"
        }
    }
}
