//
//  MdastTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 13/7/21.
//

import XCTest
@testable import PMAST

class MdastTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDoubleTrailingNewline() throws {
        var md: Markdown
        md = Markdown("[google.com](https://google.com)")
        md = Markdown("[google.com](google.com)")
        md = Markdown("google.com")
        md = Markdown("user@gmail.com")
    }
}
