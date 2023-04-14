import Foundation

final class SongLinkService {

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
