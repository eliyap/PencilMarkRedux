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
        print("\(#function) called, but not implemented!")
    }
    
    func updateChangeCount(_ change: UIDocument.ChangeKind) {
        print("\(#function) called, but not implemented!")
    }
    
    func save(to url: URL, for saveOperation: UIDocument.SaveOperation, completionHandler: ((Bool) -> Void)?) {
        print("\(#function) called, but not implemented!")
    }
    
    func open(completionHandler: ((Bool) -> Void)?) {
        print("\(#function) called, but not implemented!")
    }
    
    init(_ string: String) {
        markdown = Markdown(string)
    }
}

