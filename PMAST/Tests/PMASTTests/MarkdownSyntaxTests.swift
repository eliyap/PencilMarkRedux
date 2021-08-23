//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import XCTest
@testable import PMAST

/**
 Check that all the standard Markdown formatting we expect is available.
 Checked according to GFM spec.
 */
class ListItemTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnorderedListItems() throws {
        XCTAssertTrue("-".isUnorderedListItem())
        XCTAssertTrue("*".isUnorderedListItem())
        XCTAssertTrue("+".isUnorderedListItem())
        
        XCTAssertTrue("* An Item".isUnorderedListItem())
        XCTAssertFalse("*An Item".isUnorderedListItem())
    }
    
    func testOrderedListItems() throws {
        XCTAssertTrue("0.".isOrderedListItem())
        XCTAssertTrue("1.".isOrderedListItem())
        XCTAssertTrue("123456789.".isOrderedListItem())
        
        XCTAssertTrue("1. An Item".isOrderedListItem())
        
        XCTAssertFalse("-1. An Item".isOrderedListItem())
        XCTAssertFalse("1.An Item".isOrderedListItem())
        XCTAssertFalse("1234567890. An Item".isOrderedListItem())
    }
}
