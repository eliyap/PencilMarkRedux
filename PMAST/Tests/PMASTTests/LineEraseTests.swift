//
//  LineEraseTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 16/7/21.
//

import XCTest
@testable import PMAST

class LineEraseTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// make sure zero length ranges are rejected
    func testZeroRange() throws {
        var document = Markdown("")
        
        document = Markdown("aaa")
        document.erase(to: NSMakeRange(1, 0))
        XCTAssertEqual(document.plain, "aaa")
    }

    /// Basic erase of part of a string
    func testMid() throws {
        var document = Markdown("")
        
        document = Markdown("aDELETEa")
        document.erase(to: NSMakeRange(1, 6))
        XCTAssertEqual(document.plain, "aa")
    }
    
    /// Erasing part of a phrasing block, make sure the phrasing block isn't broken
    func testPartial() throws {
        var document = Markdown("")
        
        document = Markdown("_aaBB_ BBaa")
        document.erase(to: NSMakeRange(3, 6)) /// target 'BB_ BB'
        XCTAssertEqual(document.plain, "_aa_aa")
    }
    
    func testComplete() throws {
        var document = Markdown("")
        
        document = Markdown("a _BBB_ a")
        document.erase(to: NSMakeRange(3, 3)) /// target 'BBB'
        XCTExpectFailure("Haven't implemented smart whitespace removal") {
            XCTAssertEqual(document.plain, "a a") /// is actually "a  a" (two spaces)
        }
    }
    
    /// test deep nesting of phrasing blocks
    func testNestedPhrasing() throws {
        var document = Markdown("")
        
        document = Markdown("_BBB_")
        document.erase(to: NSMakeRange(1, 3)) /// target 'BBB'
        XCTAssertEqual(document.plain, "")
        
        document = Markdown("**~~_BBB_~~**")
        document.erase(to: NSMakeRange(5, 3)) /// target 'BBB'
        XCTAssertEqual(document.plain, "")
        
        /// try multiple nested phrasing blocks
        document = Markdown("**~~_BBB_~~ ~~_BBB_~~ _BBB_**")
        document.erase(to: NSMakeRange(5, 21)) /// target 'BBB_~~ ~~_BBB_~~ _BBB'
        XCTAssertEqual(document.plain, "")
        
        /// check simple Headings
        document = Markdown("# BBB")
        document.erase(to: NSMakeRange(2, 3)) /// target 'BBB'
        XCTAssertEqual(document.plain, "")
        
        /// check styled headings
        document = Markdown("# ~~*BBB*~~")
        document.erase(to: NSMakeRange(5, 3)) /// target 'BBB'
        XCTAssertEqual(document.plain, "")
        
        /// Check headings with extra whitespace
        document = Markdown("###   BBB")
        document.erase(to: NSMakeRange(6, 3)) /// target 'BBB'
        XCTAssertEqual(document.plain, "")
        
        /// Check Setext style headings
        document = Markdown("""
            BBB
            ===
            """)
        document.erase(to: NSMakeRange(0, 3)) /// target 'BBB'
        XCTAssertEqual(document.plain, "")
        
    }
    
    /// test nesting of list items
    func testNestedLists() throws {
        var document = Markdown("")
        
        /// simple list item check
        document = Markdown("- BBB")
        document.erase(to: NSMakeRange(2, 3)) /// target 'BBB'
        XCTAssertEqual(document.plain, "")
        
        /// nested list check
        document = Markdown("- - BBB")
        document.erase(to: NSMakeRange(4, 3)) /// target 'BBB'
        XCTAssertEqual(document.plain, "")
        
        /// multi-item list check
        document = Markdown("""
            - BBB
            - aaa
            """)
        document.erase(to: NSMakeRange(2, 3)) /// target 'BBB'
        XCTExpectFailure("Haven't implemented list removal") {
            XCTAssertEqual(document.plain, "- aaa") /// includes extra newline
        }
        
        /// list with leading spaces
        document = Markdown("-   BBB")
        document.erase(to: NSMakeRange(4, 3)) /// target 'BBB'
        XCTAssertEqual(document.plain, "")
        
        /// list with phrasing formatting
        document = Markdown("- ~~**BBB**~~")
        document.erase(to: NSMakeRange(6, 3)) /// target 'BBB'
        XCTAssertEqual(document.plain, "")
    }
}
