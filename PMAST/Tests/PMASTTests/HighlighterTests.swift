//
//  HighlighterTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 21.09.11.
//

import XCTest
@testable import PMAST

/**
 Check that all the standard Markdown formatting we expect is available.
 */
class HighlighterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTrailingNewline() throws {
        var document: Markdown
        
        document = Markdown("AAA\nBBB")
        document.apply(lineStyle: Mark.self, to: [NSMakeRange(0, 4)]) /// Target `AAA\n`
        XCTAssertEqual(document.plain, "==AAA==\nBBB")
        
        document = Markdown("AAA\nBBB")
        document.apply(lineStyle: Delete.self, to: [NSMakeRange(0, 4)]) /// Target `AAA\n`
        XCTAssertEqual(document.plain, "~~AAA~~\nBBB")
        
        document = Markdown("AAA\nBBB")
        document.apply(lineStyle: Emphasis.self, to: [NSMakeRange(0, 4)]) /// Target `AAA\n`
        XCTAssertTrue(document.plain == "*AAA*\nBBB" || document.plain == "_AAA_\nBBB")
        
        document = Markdown("AAA\nBBB")
        document.apply(lineStyle: Strong.self, to: [NSMakeRange(0, 4)]) /// Target `AAA\n`
        XCTAssertTrue(document.plain == "**AAA**\nBBB" || document.plain == "__AAA__\nBBB")
    }
    
    func testListItem() throws {
        var document: Markdown
        
        document = Markdown("AAA\n- BBB")
        document.apply(lineStyle: Mark.self, to: [NSMakeRange(4, 5)]) /// Target `- BBB`
        XCTAssertEqual(document.plain, "AAA\n- ==BBB==")
    }
}
