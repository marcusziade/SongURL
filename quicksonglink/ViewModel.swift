//
//  ViewModel.swift
//  quicksonglink
//
//  Created by Marcus Ziadé on 12.8.2022.
//

import AppKit
import Combine
import Foundation

final class ViewModel: ObservableObject {
    
    enum State: Equatable {
        static func == (lhs: ViewModel.State, rhs: ViewModel.State) -> Bool {
            lhs.title == rhs.title &&
            lhs.isSuccess == rhs.isSuccess
        }
        
        case loading
        case result(link: LinksResponse, message: String)
        case error(message: String)
        case idle
        
        var title: String {
            switch self {
            case .loading:
                return "Loading"
            case .result(_, message: let message):
                return message
            case .error(message: let message):
                return message
            case .idle:
                return ""
            }
        }
        
        var isSuccess: Bool {
            switch self {
            case .loading, .error(_), .idle:
                return false
            case .result(_, _):
                return true
            }
        }
    }
    
    @Published var searchURL = ""
    @Published var state: State = .idle
    
    init(service: SongLinkService) {
        self.service = service
        
        $searchURL
            .sink { [unowned self] link in
                Task { try await generate() }
            }
            .store(in: &cancellables)
        
        $state
            .sink { [unowned self] state in
                switch state {
                case .result(let link, _):
                    copyLinkToClipboard(link)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor func generate() async throws {
        if searchURL.isEmpty {
            state = .idle
            return
        }
        
        state = .loading
        
        do {
            state = .result(
                link: try await service.songLink(for: searchURL),
                message: "Song.link URL copied to the clipboard"
            )
        } catch let error as HTTPError {
            state = .error(message: error.description)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }
        
    // MARK: Private
    
    private let service: SongLinkService
    
    private var cancellables = Set<AnyCancellable>()
    
    private func copyLinkToClipboard(_ link: LinksResponse) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: self)
        pasteboard.setString(link.nonLocalPageURL, forType: .string)
    }
}
