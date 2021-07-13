//
//  StrikethroughTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 13/7/21.
//

import XCTest
@testable import PencilMarkRedux

class StrikethroughTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Strikes through the middle of a line
    func testMidStrike() throws {
        var document = StyledMarkdown(text: "aSTRIKEa")
        document.apply(lineStyle: Delete.self, to: _NSRange(location: 1, length: 6))
        XCTAssertEqual(document.text, "a~~STRIKE~~a")
    }
    
    /// Strikes an entire phrasing element and its surroundings
    func testEnclosingStrike() throws {
        var document = StyledMarkdown(text: "aS _SSS_ Sa")
        document.apply(lineStyle: Delete.self, to: _NSRange(location: 1, length: 9))
        XCTAssertEqual(document.text, "a~~S _SSS_ S~~a")
    }
    
    /// Strikes partly inside, partly outside a phrasing block
    func testPartialStrike() throws {
        var document = StyledMarkdown(text: "_aaBB_ BBaa")
        document.apply(lineStyle: Delete.self, to: _NSRange(location: 3, length: 6))
        XCTExpectFailure("Eject Whitespace not ported yet!")
        XCTAssertEqual(document.text, "_aa~~BB~~_ ~~BB~~aa")
    }
    
    /// Strikes through a block enclosing a `delete` already.
    /// Expect it to unwrap that enclosed block.
    func testUnwrapStrike() throws {
        var document = StyledMarkdown(text: "aS _~~SSS~~_ Sa")
        document.apply(lineStyle: Delete.self, to: _NSRange(location: 1, length: 13))
        XCTAssertEqual(document.text, "a~~S _SSS_ S~~a")
    }
}
