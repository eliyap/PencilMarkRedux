//
//  File.swift
//
//
//  Created by Secret Asian Man Dev on 21/8/21.
//

import XCTest
@testable import PMAST

/**
 Check that all the standard Markdown formatting we expect is available.
 */
class ASTTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnorderedListItems() throws {
        var document = Markdown("""
            Some Stuff
            """)
        
        let new = """
            Some Stuff
            
            More Stuff
            """
        
        document.patch(with: new)
    }
    
    func checkPatch(old: String, new: String) {
        var document = Markdown(old)
        document.patch(with: new)
        XCTAssertEqual(document.ast, Markdown(new).ast)
    }
}
