//
//  LinksResponse_Tests.swift
//  quicksonglinkTests
//
//  Created by Marcus Ziadé on 28.8.2022.
//

import XCTest

@testable import SongLink

final class LinksResponse_Tests: XCTestCase {
    
    func testNonLocalURLGeneration() {
        XCTAssertFalse(response.nonLocalPageURL.contains("/fi"))
    }
    
    func testProperties() {
        XCTAssertTrue(response.artist.contains("deadmau5"))
        XCTAssertTrue(response.title.contains("here's the drop!"))
        XCTAssertEqual(response.type, .album)
        XCTAssertEqual(response.type.icon, "rectangle.stack")
    }
    
    // MARK: Private
    
    private let response = LinksResponse.mock
}
