//
//  KeyboardEditorView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import SwiftUI

struct KeyboardEditorView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = KeyboardEditorViewController
    
    let strokeC: StrokeConduit
    
    func makeUIViewController(context: Context) -> KeyboardEditorViewController {
        let vc = UIViewControllerType(strokeC: strokeC)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: KeyboardEditorViewController, context: Context) {
        /// nothing
    }
}
