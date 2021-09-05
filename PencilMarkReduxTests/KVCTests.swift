//
//  KVCTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 5/9/21.
//

import Foundation
import XCTest
@testable import PencilMarkRedux

class KVCTests: XCTestCase {
    
    override func setUpWithError() throws {
    
    }

    override func tearDownWithError() throws {
    
    }

    func testBasic() throws {
        let model = DrawableMarkdownViewController.Model(document: document, onSetTool: { /* nothing */})
        KeyboardViewController(model: model)
    }
}
