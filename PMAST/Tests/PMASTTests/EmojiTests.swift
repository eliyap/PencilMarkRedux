//
//  EmojiTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 21.09.05.
//

import XCTest
@testable import PMAST

class EmojiTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStrikethroughAvailable() throws {
        var md = Markdown("💩")
        md.apply(lineStyle: Delete.self, to: [NSMakeRange(0, 2)])
        
        XCTAssertEqual(md.plain, "~~💩~~")
    }
    
    func testEmphasisAvailable() throws {

    }
    
    func testStrongAvailable() throws {

    }
}
