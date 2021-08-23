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
    
    func testInsert() throws {
        /// Insert Before
        XCTExpectFailure() {
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
        
        /// Insert After
        XCTExpectFailure() {
            checkPatch(
                old: """
                Old Text
                """,
                new: """
                Old Text
                
                New Text
                """
            )
        }
    }
    
    /// Generic function for checking ``Markdown.patch``.
    func checkPatch(old: String, new: String) {
        var oldMD = Markdown(old)
        oldMD.patch(with: new)
        let diff = oldMD.ast.description.difference(from: Markdown(new).ast.description)
        XCTAssertEqual(diff.count, 0, "\(diff.report())")
    }
}
