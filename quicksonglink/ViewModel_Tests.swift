import XCTest

@testable import SongLink

final class ViewModel_Tests: XCTestCase {
    
    func testGenerateSuccesfully() async throws {
        model.searchURL = "https://music.apple.com/fi/album/heres-the-drop/1480004024"
        try await model.generate()
        XCTAssertEqual(model.state, .result(link: LinksResponse.mock, message: "Song.link URL copied to the clipboard"))
    }
    
    func testBadSearchLink() async throws {
        model.searchURL = "hts:BADURL/"
        try await model.generate()
        XCTAssertEqual(model.state, .error(message: "❌ Bad response. Check your link for errors."))
    }
    
    func testState() async throws {
        XCTAssertEqual(model.state, .idle)
        
        model.searchURL = "hts:BADURL/"
        model.state = .loading
        XCTAssertEqual(model.state, .loading)
        try await model.generate()
        XCTAssertEqual(model.state, .error(message: "❌ Bad response. Check your link for errors."))

        model.searchURL = "https://music.apple.com/fi/album/heres-the-drop/1480004024"
        try await model.generate()
        XCTAssertEqual(model.state, .result(link: LinksResponse.mock, message: "Song.link URL copied to the clipboard"))
        
        model.searchURL = ""
        try await model.generate()
        XCTAssertEqual(model.state, .idle)
    }

    // MARK: Private
    
    private let model = ViewModel(service: SongLinkService())
}

