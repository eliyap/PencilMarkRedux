//
//  FormatTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 13/7/21.
//

import XCTest
@testable import PencilMarkRedux

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
        var document = StyledMarkdownDocument(text: "a FORMAT a")
        let textView = PMTextView() /// dummy view to satisfy function signature
        
        document.apply(lineStyle: Delete.self, to: NSMakeRange(2, 6), in: textView)
        XCTAssertEqual(document.text, "a ~~FORMAT~~ a")
    }
    
    func testEmphasisAvailable() throws {
        var document = StyledMarkdownDocument(text: "a FORMAT a")
        let textView = PMTextView() /// dummy view to satisfy function signature
        
        document.apply(lineStyle: Emphasis.self, to: NSMakeRange(2, 6), in: textView)
        /// accept either kind of emphasis marker
        XCTAssertTrue(document.text == "a _FORMAT_ a" || document.text == "a *FORMAT* a")
    }
    
    func testStrongAvailable() throws {
        var document = StyledMarkdownDocument(text: "a FORMAT a")
        let textView = PMTextView() /// dummy view to satisfy function signature
        
        document.apply(lineStyle: Strong.self, to: NSMakeRange(2, 6), in: textView)
        /// accept either kind of emphasis marker
        XCTAssertTrue(document.text == "a __FORMAT__ a" || document.text == "a **FORMAT** a")
    }
}
