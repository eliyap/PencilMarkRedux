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
        var document = Markdown("""
            Some Stuff
            """)
        
        document.updateTree(with: """
            new line
            
            Some Stuff
            
            AND MORE!
            """)
    }
}
