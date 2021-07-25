//
//  FormatTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 13/7/21.
//

import XCTest
@testable import PMAST

/**
 Check that all the standard Markdown formatting we expect is available.
 */
class FormatTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStrikethroughAvailable() throws {
        var document = Markdown( "a FORMAT a")
        
        document.apply(lineStyle: Delete.self, to: NSMakeRange(2, 6))
        XCTAssertEqual(document.plain, "a ~~FORMAT~~ a")
    }
    
    func testEmphasisAvailable() throws {
        var document = Markdown( "a FORMAT a")
        
        document.apply(lineStyle: Emphasis.self, to: NSMakeRange(2, 6))
        /// accept either kind of emphasis marker
        XCTAssertTrue(document.plain == "a _FORMAT_ a" || document.plain == "a *FORMAT* a")
    }
    
    func testStrongAvailable() throws {
        var document = Markdown( "a FORMAT a")
        
        document.apply(lineStyle: Strong.self, to: NSMakeRange(2, 6))
        /// accept either kind of emphasis marker
        XCTAssertTrue(document.plain == "a __FORMAT__ a" || document.plain == "a **FORMAT** a")
    }
}
