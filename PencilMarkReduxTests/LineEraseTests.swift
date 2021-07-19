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
        let textView = PMTextView() /// dummy view to satisfy function signature
        
        document = StyledMarkdown(text: "aaa")
        document.erase(to: NSMakeRange(1, 0), in: textView)
        XCTAssertEqual(document.text, "aaa")
    }

    /// Basic erase of part of a string
    func testMid() throws {
        var document = StyledMarkdown()
        let textView = PMTextView() /// dummy view to satisfy function signature
        
        document = StyledMarkdown(text: "aDELETEa")
        document.erase(to: NSMakeRange(1, 6), in: textView)
        XCTAssertEqual(document.text, "aa")
    }
    
    /// Erasing part of a phrasing block, make sure the phrasing block isn't broken
    func testPartial() throws {
        var document = StyledMarkdown()
        let textView = PMTextView() /// dummy view to satisfy function signature
        
        document = StyledMarkdown(text: "_aaBB_ BBaa")
        document.erase(to: NSMakeRange(3, 6), in: textView) /// target 'BB_ BB'
        XCTAssertEqual(document.text, "_aa_aa")
    }
    
    func testComplete() throws {
        var document = StyledMarkdown()
        let textView = PMTextView() /// dummy view to satisfy function signature
        
        document = StyledMarkdown(text: "a _BBB_ a")
        document.erase(to: NSMakeRange(3, 3), in: textView) /// target 'BBB'
        XCTExpectFailure("Haven't implemented smart whitespace removal") {
            XCTAssertEqual(document.text, "a a") /// is actually "a  a" (two spaces)
        }
    }
    
    /// test deep nesting of phrasing blocks
    func testNestedPhrasing() throws {
        var document = StyledMarkdown()
        let textView = PMTextView() /// dummy view to satisfy function signature
        
        document = StyledMarkdown(text: "_BBB_")
        document.erase(to: NSMakeRange(1, 3), in: textView) /// target 'BBB'
        XCTAssertEqual(document.text, "")
        
        document = StyledMarkdown(text: "**~~_BBB_~~**")
        document.erase(to: NSMakeRange(5, 3), in: textView) /// target 'BBB'
        XCTAssertEqual(document.text, "")
        
        /// try multiple nested phrasing blocks
        document = StyledMarkdown(text: "**~~_BBB_~~ ~~_BBB_~~ _BBB_**")
        document.erase(to: NSMakeRange(5, 21), in: textView) /// target 'BBB_~~ ~~_BBB_~~ _BBB'
        XCTAssertEqual(document.text, "")
        
        /// check simple Headings
        document = StyledMarkdown(text: "# BBB")
        document.erase(to: NSMakeRange(2, 3), in: textView) /// target 'BBB'
        XCTAssertEqual(document.text, "")
        
        /// check styled headings
        document = StyledMarkdown(text: "# ~~*BBB*~~")
        document.erase(to: NSMakeRange(5, 3), in: textView) /// target 'BBB'
        XCTAssertEqual(document.text, "")
        
        /// Check headings with extra whitespace
        document = StyledMarkdown(text: "###   BBB")
        document.erase(to: NSMakeRange(6, 3), in: textView) /// target 'BBB'
        XCTAssertEqual(document.text, "")
        
        /// Check Setext style headings
        document = StyledMarkdown(text: """
            BBB
            ===
            """)
        document.erase(to: NSMakeRange(0, 3), in: textView) /// target 'BBB'
        XCTAssertEqual(document.text, "")
        
    }
    
    /// test nesting of list items
    func testNestedLists() throws {
        var document = StyledMarkdown()
        let textView = PMTextView() /// dummy view to satisfy function signature
        
        /// simple list item check
        document = StyledMarkdown(text: "- BBB")
        document.erase(to: NSMakeRange(2, 3), in: textView) /// target 'BBB'
        XCTAssertEqual(document.text, "")
        
        /// nested list check
        document = StyledMarkdown(text: "- - BBB")
        document.erase(to: NSMakeRange(4, 3), in: textView) /// target 'BBB'
        XCTAssertEqual(document.text, "")
        
        /// multi-item list check
        document = StyledMarkdown(text: """
            - BBB
            - aaa
            """)
        document.erase(to: NSMakeRange(2, 3), in: textView) /// target 'BBB'
        XCTExpectFailure("Haven't implemented list removal") {
            XCTAssertEqual(document.text, "- aaa") /// includes extra newline
        }
        
        /// list with leading spaces
        document = StyledMarkdown(text: "-   BBB")
        document.erase(to: NSMakeRange(4, 3), in: textView) /// target 'BBB'
        XCTAssertEqual(document.text, "")
        
        /// list with phrasing formatting
        document = StyledMarkdown(text: "- ~~**BBB**~~")
        document.erase(to: NSMakeRange(6, 3), in: textView) /// target 'BBB'
        XCTAssertEqual(document.text, "")
    }
}
