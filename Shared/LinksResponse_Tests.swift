import XCTest

@testable import SongURL

final class LinksResponse_Tests: XCTestCase {
    
    func testNonLocalURLGeneration() {
        XCTAssertFalse(response.nonLocalPageURL.contains("/fi"))
    }
    
    func testProperties() {
        XCTAssertTrue(response.artist.contains("Brandberg"))
        XCTAssertTrue(response.title.contains("Anubis"))
        XCTAssertEqual(response.type, .song)
        XCTAssertEqual(response.type.icon, "music.note")
    }
    
    // MARK: Private
    
    private let response = SongLinkService.mockLinks
}
