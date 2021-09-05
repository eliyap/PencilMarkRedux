//
//  MockDocument.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 5/9/21.
//

import Foundation
import PMAST
import UIKit
@testable import PencilMarkRedux

final class MockDocument: MockableDocument {
    /// FAKE DATA
    var documentState: UIDocument.State = .normal
    
    /// FAKE DATA
    var fileURL: URL = URL.init(fileURLWithPath: "DO NOT USE")
    
    var markdown: Markdown
    
    var undoManager: UndoManager!
    
    var localizedName: String = "DO NOT USE"
    
    func close(completionHandler: ((Bool) -> Void)?) {
        /// Nothing.
    }
    
    func updateChangeCount(_ change: UIDocument.ChangeKind) {
        /// Nothing.
    }
    
    func save(to url: URL, for saveOperation: UIDocument.SaveOperation, completionHandler: ((Bool) -> Void)?) {
        /// Nothing.
    }
    
    func open(completionHandler: ((Bool) -> Void)?) {
        /// Nothing.
    }
    
    init(_ string: String) {
        markdown = Markdown(string)
    }
}

