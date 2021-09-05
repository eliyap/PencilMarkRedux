//
//  MockableDocument.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 5/9/21.
//

import UIKit
import PMAST

/**
 Defines the shape of our document object so that it can be simulated in tests.
 */
public protocol MockableDocument {
    var documentState: UIDocument.State { get }
    var fileURL: URL { get }
    var markdown: Markdown { get set }
    var undoManager: UndoManager! { get }
    var localizedName: String { get }
    func close(completionHandler: ((Bool) -> Void)?)
    func updateChangeCount(_ change: UIDocument.ChangeKind)
    func save(to url: URL, for saveOperation: UIDocument.SaveOperation, completionHandler: ((Bool) -> Void)?)
    func open(completionHandler: ((Bool) -> Void)?)
}
