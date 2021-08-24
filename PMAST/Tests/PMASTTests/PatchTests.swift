//
//  PatchTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 13/7/21.
//

import XCTest
@testable import PMAST

class PatchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEqual() throws {
        checkPatch(
            old: """
            Old Text
            """,
            new: """
            Old Text
            """
        )
    }
    
    func testNewlineBefore() throws {
        /// Insert Before
        checkPatch(
            old: """
            Old Text
            """,
            new: """
            
            Old Text
            """
        )
    }
    
    func testNewlineAfter() throws {
        /// Insert Before
        checkPatch(
            old: """
            Old Text
            """,
            new: """
            
            Old Text
            """
        )
    }
    
    func testInsertLineBefore() throws {
        checkPatch(
            old: """
            Old Text
            """,
            new: """
            New Text
            
            Old Text
            """
        )
    }
    
    func testInsertLineAfter() throws {
        /// Insert After
        checkPatch(
            old: """
            Old Text
            """,
            new: """
            Old Text

            New Text
            """
        )
        
        /// Insert After
        checkPatch(
            old: """
            Old Text
            """,
            new: """
            Old Text

            New Text Long Line
            """
        )
    }
    
    func testModifyLines() throws {
        checkPatch(
            old: """
            Old Text 1
            
            Old Text 2
            """,
            new: """
            New Text 1
            
            New Text 2
            """
        )
    }
    
    func testBreakBlock() throws {
        checkPatch(
            old: """
            ~~Old Text 1
            Old Text 2~~
            """,
            new: """
            ~~Old Text 1
            
            Old Text 2~~
            """
        )
    }
    
    func testJoinBlock() throws {
        checkPatch(
            old: """
            ~~Old Text 1
            
            Old Text 2~~
            """,
            new: """
            ~~Old Text 1
            Old Text 2~~
            """
        )
    }
    
    func testCloseFormatting() throws {
        /// Close at the end.
        checkPatch(
            old: """
            ~~Old Text 1
            Old Text 2
            """,
            new: """
            ~~Old Text 1
            Old Text 2~~
            """
        )
        
        /// Close at the beginning.
        checkPatch(
            old: """
            Old Text 1
            Old Text 2~~
            """,
            new: """
            ~~Old Text 1
            Old Text 2~~
            """
        )
    }
    
    func testUncloseFormatting() throws {
        /// Unclose at the end.
        checkPatch(
            old: """
            ~~Old Text 1
            Old Text 2~~
            """,
            new: """
            ~~Old Text 1
            Old Text 2
            """
        )
        
        /// Unclose at the beginning.
        checkPatch(
            old: """
            ~~Old Text 1
            Old Text 2~~
            """,
            new: """
            Old Text 1
            Old Text 2~~
            """
        )
    }
    
    func testBreakQuotation() throws {
        /// Unclose at the beginning.
        checkPatch(
            old: """
            > quote line 1
            > quote line 2
            """,
            new: """
            > quote line 1
            
            > quote line 2
            """
        )
    }
    
    func testJoinQuotation() throws {
        /// Unclose at the beginning.
        checkPatch(
            old: """
            > quote line 1
            
            > quote line 2
            """,
            new: """
            > quote line 1
            > quote line 2
            """
        )
    }
    
    /// Generic function for checking ``Markdown.patch``.
    func checkPatch(old: String, new: String) {
        var oldMD = Markdown(old)
        oldMD.patch(with: new)
        let oldDescription = oldMD.ast.description
        let newDescription = Markdown(new).ast.description
        let diff = oldDescription.difference(from: newDescription)
        
        /// Check that there are no differences, and print a detailed report of the differences if there are any.
        XCTAssertEqual(diff.count, 0, "\(diff.report())\n\(oldDescription)\n\(newDescription)")
    }
}
