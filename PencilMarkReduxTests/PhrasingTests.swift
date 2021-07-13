//
//  PhrasingTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 13/7/21.
//

import XCTest
@testable import PencilMarkRedux

class PhrasingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Formats through the middle of a line
    func testMid() throws {
        var document = StyledMarkdown()
        
        /// ~~DELETE~~
        document = StyledMarkdown(text: "aSTRIKEa")
        document.apply(lineStyle: Delete.self, to: _NSRange(location: 1, length: 6))
        XCTAssertEqual(document.text, "a~~STRIKE~~a")
        
        /// **STRONG**
        document = StyledMarkdown(text: "aSTRIKEa")
        document.apply(lineStyle: Strong.self, to: _NSRange(location: 1, length: 6))
        XCTAssertTrue(document.text == "a**STRIKE**a" || document.text == "a__STRIKE__a")
        
        /// *EMPHASIS*
        document = StyledMarkdown(text: "aSTRIKEa")
        document.apply(lineStyle: Emphasis.self, to: _NSRange(location: 1, length: 6))
        XCTAssertTrue(document.text == "a*STRIKE*a" || document.text == "a_STRIKE_a")
    }
    
    /// Strikes an entire phrasing element and its surroundings
    func testEnclosing() throws {
        var document = StyledMarkdown()
        
        /// ~~DELETE~~
        document = StyledMarkdown(text: "aS _SSS_ Sa")
        document.apply(lineStyle: Delete.self, to: _NSRange(location: 1, length: 9))
        XCTAssertEqual(document.text, "a~~S _SSS_ S~~a")
        
        /// **STRONG**
        document = StyledMarkdown(text: "aS _SSS_ Sa")
        document.apply(lineStyle: Strong.self, to: _NSRange(location: 1, length: 9))
        XCTAssertTrue(document.text == "a**S _SSS_ S**a" || document.text == "a__S _SSS_ S__a")
        
        /// *EMPHASIS*
        document = StyledMarkdown(text: "aS **SSS** Sa")
        document.apply(lineStyle: Emphasis.self, to: _NSRange(location: 1, length: 11))
        XCTAssertTrue(document.text == "a*S **SSS** S*a" || document.text == "a_S **SSS** S_a")
    }
    
    /// Strikes partly inside, partly outside a phrasing block
    func testPartial() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "_aaBB_ BBaa")
        document.apply(lineStyle: Delete.self, to: _NSRange(location: 3, length: 6))
        XCTExpectFailure("Eject Whitespace not ported yet!")
        XCTAssertEqual(document.text, "_aa~~BB~~_ ~~BB~~aa")
    }
    
    /// Strikes through a block enclosing a `delete` already.
    /// Expect it to unwrap that enclosed block.
    func testUnwrap() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "aS _~~SSS~~_ Sa")
        document.apply(lineStyle: Delete.self, to: _NSRange(location: 1, length: 13))
        XCTAssertEqual(document.text, "a~~S _SSS_ S~~a")
    }
}
