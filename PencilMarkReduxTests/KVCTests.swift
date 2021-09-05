//
//  KVCTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 5/9/21.
//

import XCTest
@testable import PMAST
@testable import PencilMarkRedux

class KVCTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
    
    }

    func testBasic() throws {
        let document = MockDocument("SOME TEXT")
        let model = DrawableMarkdownViewController.Model(document: document, onSetTool: { /* nothing */})
        let kvc = KeyboardViewController(model: model)
        kvc.__erase(NSMakeRange(0, 9))
        
        XCTAssert(document.markdown.plain == "")
        checkASTConsistent(document.markdown.ast, with: "")
    }
    
    func checkASTConsistent(_ ast: Root, with string: String) {
        let newAST: Root = Markdown(string).ast
        let old = ast.description
        let new = newAST.description
        XCTAssertEqual(old.difference(from: new).count, 0)
    }
}
