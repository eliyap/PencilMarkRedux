//
//  LineEraseTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 16/7/21.
//

import XCTest
@testable import PencilMarkRedux

class LineEraseTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// make sure zero length ranges are rejected
    func testZeroRange() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "aaa")
        document.erase(in: _NSRange(location: 1, length: 0))
        XCTAssertEqual(document.text, "aaa")
    }

    /// Basic erase of part of a string
    func testMid() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "aDELETEa")
        document.erase(in: _NSRange(location: 1, length: 6))
        XCTAssertEqual(document.text, "aa")
    }
    
    /// Erasing part of a phrasing block, make sure the phrasing block isn't broken
    func testPartial() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "_aaBB_ BBaa")
        document.erase(in: _NSRange(location: 3, length: 6)) /// target 'BB_ BB'
        XCTAssertEqual(document.text, "_aa_aa")
    }
    
    func testComplete() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "a _BBB_ a")
        document.erase(in: _NSRange(location: 3, length: 3)) /// target 'BBB'
        XCTExpectFailure("Haven't implemented smart whitespace removal") {
            XCTAssertEqual(document.text, "a a") /// is actually "a  a" (two spaces)
        }
    }
    
    /// test deep nesting of phrasing blocks
    func testNestedPhrasing() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "_BBB_")
        document.erase(in: _NSRange(location: 1, length: 3)) /// target 'BBB'
        XCTAssertEqual(document.text, "")
        
        document = StyledMarkdown(text: "**~~_BBB_~~**")
        document.erase(in: _NSRange(location: 5, length: 3)) /// target 'BBB'
        XCTAssertEqual(document.text, "")
        
        /// try multiple nested phrasing blocks
        document = StyledMarkdown(text: "**~~_BBB_~~ ~~_BBB_~~ _BBB_**")
        document.erase(in: _NSRange(location: 5, length: 21)) /// target 'BBB_~~ ~~_BBB_~~ _BBB'
        XCTAssertEqual(document.text, "")
        
        /// check Headings
        document = StyledMarkdown(text: "# BBB")
        document.erase(in: _NSRange(location: 2, length: 3)) /// target 'BBB'
        XCTExpectFailure("Haven't implemented heading removal") {
            XCTAssertEqual(document.text, "")
        }
        
        document = StyledMarkdown(text: "# ~~*BBB*~~")
        document.erase(in: _NSRange(location: 5, length: 3)) /// target 'BBB'
        XCTExpectFailure("Haven't implemented heading removal") {
            XCTAssertEqual(document.text, "")
        }
    }
    
    /// test nesting of list items
    func testNestedLists() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "- BBB")
        document.erase(in: _NSRange(location: 2, length: 3)) /// target 'BBB'
        XCTExpectFailure("Haven't implemented list removal") {
            XCTAssertEqual(document.text, "")
        }
        
        document = StyledMarkdown(text: "- - BBB")
        document.erase(in: _NSRange(location: 4, length: 3)) /// target 'BBB'
        XCTExpectFailure("Haven't implemented list removal") {
            XCTAssertEqual(document.text, "")
        }
        
        document = StyledMarkdown(text: """
            - BBB
            - aaa
            """)
        document.erase(in: _NSRange(location: 2, length: 3)) /// target 'BBB'
        XCTExpectFailure("Haven't implemented list removal") {
            XCTAssertEqual(document.text, "- aaa")
        }
    }
}
