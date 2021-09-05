//
//  PatchTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 13/7/21.
//

import XCTest
@testable import PMAST

class PatchStressTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// For now, use a basic set of ASCII.
    let chars = "1234567890qwertyuiopasdfghjklzxcvbnm,.|[]()-+=~`!@#$%^&*_"
    
    func randString(length: Int) -> String {
        /// Weight newlines heavily to encourage chunks.
        .init((0..<length).map { _ in
            if (0..<10).randomElement() == 0 {
                return "\n"
            } else {
                return chars.randomElement()!
            }
        })
    }
    
    func testRandomStrings() throws {
        (0..<10).forEach { _ in
            checkPatch([
                randString(length: 1000),
                randString(length: 1000),
                randString(length: 1000),
            ])
        }
    }
    
    /// Array version of checker.
    func checkPatch(_ strings: [String]) {
        var md = Markdown("")
        for string in strings {
            md.patch(with: string)
            let old = md.ast.description
            let new = Markdown(string).ast.description
            let diff = old.difference(from: new)
            /// Check that there are no differences, and print a detailed report of the differences if there are any.
            XCTAssertEqual(diff.count, 0, "\(diff.report())\nPatch: \(old)\nOld:\(md.plain)\nFresh: \(new)\nNew:\(string)")
            
            /// Remember to set the text also!
            md.plain = string
        }
    }
}
