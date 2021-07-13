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
    @Binding var document: StyledMarkdown
    
    func makeUIViewController(context: Context) -> KeyboardEditorViewController {
        let vc = UIViewControllerType(coordinator: context.coordinator, strokeC: strokeC)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: KeyboardEditorViewController, context: Context) {
        /// nothing
    }
}

extension KeyboardEditorView {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(document: $document)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var document: StyledMarkdown
        
        init(document: Binding<StyledMarkdown>) {
            self._document = document
        }
        
        // TODO: use keyboard edits.
//        func textViewDidChange(_ textView: UITextView) {
//            text = textView.text
//        }
    }
}
