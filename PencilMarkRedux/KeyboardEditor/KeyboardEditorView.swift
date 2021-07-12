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
    @Binding var text: String
    
    func makeUIViewController(context: Context) -> KeyboardEditorViewController {
        let vc = UIViewControllerType(strokeC: strokeC)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: KeyboardEditorViewController, context: Context) {
        /// nothing
    }
}

extension KeyboardEditorView {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
    }
}
