//
//  PatchTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 13/7/21.
//

import XCTest
@testable import PMAST

class PatchEraseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Basic Multi Erase AST Check.
    func testBasicMultiErase() throws {
        var oldMD = Markdown("""
            1234
            1234
            """)
        oldMD.erase([
            NSMakeRange(0, 1),
            NSMakeRange(5, 1),
        ])
        
        let new = """
            234
            234
            """
        
        XCTAssertEqual(oldMD.plain, new)
        checkPatch(old: oldMD.ast, new: Markdown(new).ast)
        
        /// Further test tree by ensuring that subsequent operations do not fail.
        oldMD.erase([
            NSMakeRange(0, 1),
            NSMakeRange(4, 1),
        ])
        
        XCTAssertEqual(oldMD.plain, """
            34
            34
            """)
        
        oldMD.erase([
            NSMakeRange(0, 1),
            NSMakeRange(3, 1),
        ])
        
        XCTAssertEqual(oldMD.plain, """
            4
            4
            """)
    }
    
    /// Generic function for checking ``Markdown.patch``.
    func checkPatch(old: Root, new: Root) {
        let oldDescription = old.description
        let newDescription = new.description
        let diff = oldDescription.difference(from: newDescription)
        
        /// Check that there are no differences, and print a detailed report of the differences if there are any.
        XCTAssertEqual(diff.count, 0, "\(diff.report())\nPatch: \(oldDescription)\nFresh: \(newDescription)")
    }
}
