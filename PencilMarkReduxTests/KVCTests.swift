//
//  KVCTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 5/9/21.
//

import XCTest
@testable import PMAST
@testable import PencilMarkRedux

/// Integration tests working on the core `KeyboardViewController`.
class KVCTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
    
    }

    func testBasicEraseAll() throws {
        let text = "SOME TEXT"
        let document = MockDocument(text)
        let model = DrawableMarkdownViewController.Model(document: document, onSetTool: { /* nothing */})
        let kvc = KeyboardViewController(model: model)
        kvc.present(topInset: .zero) /// must be called to activate `textView`!
        
        /// Check state.
        XCTAssert(document.markdown.plain == text)
        XCTAssert(kvc.textView.text == text)
        checkASTConsistent(document.markdown.ast, with: text)
        
        /// Erase everything.
        kvc.__erase(NSMakeRange(0, 9))
        let newValue = ""
        XCTAssert(document.markdown.plain == newValue)
        XCTAssert(kvc.textView.text == newValue)
        checkASTConsistent(document.markdown.ast, with: newValue)
        
        /// Undo it.
        model.cmdC.undo.send()
        XCTAssertEqual(document.markdown.plain, text)
        XCTAssert(kvc.textView.text == text)
        checkASTConsistent(document.markdown.ast, with: text)
        
        /// Redo it.
        model.cmdC.redo.send()
        XCTAssertEqual(document.markdown.plain, newValue)
        XCTAssert(kvc.textView.text == newValue)
        checkASTConsistent(document.markdown.ast, with: newValue)
    }
    
    func checkASTConsistent(_ ast: Root, with string: String) {
        let newAST: Root = Markdown(string).ast
        let old = ast.description
        let new = newAST.description
        XCTAssertEqual(old.difference(from: new).count, 0)
    }
}
