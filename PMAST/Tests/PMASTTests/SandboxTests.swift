//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import XCTest
@testable import PMAST

/**
 - Warning: this is hack of the testing system to let me run code in a sandbox!
 Do not could these as actual tests!
 */
class SandboxTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }
    
    /// Do sandbox stuff here.
    func testStuffOut() throws {
        var document = Markdown("")
        
        document = Markdown("aaa")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(1, 0))
        XCTAssertEqual(document.plain, "aaa")
    }
}
