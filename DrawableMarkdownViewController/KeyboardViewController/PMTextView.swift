//
//  PMTextView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import UIKit

final class PMTextView: UITextView {
    /// reference to parent `KeyboardEditorViewController`.
    /// **Must** be set on controller's `init`.
    unowned var controller: KeyboardViewController! = nil
    
    override var undoManager: UndoManager! { controller.coordinator.undoManager }
}
