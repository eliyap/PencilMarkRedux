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
    let frameC: FrameConduit
    @Binding var document: StyledMarkdown
    
    func makeUIViewController(context: Context) -> KeyboardEditorViewController {
        let vc = UIViewControllerType(coordinator: context.coordinator, strokeC: strokeC, frameC: frameC)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: KeyboardEditorViewController, context: Context) {
        /// nothing
    }
}

extension KeyboardEditorView {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(document: $document, frameC: frameC)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var document: StyledMarkdown
        let frameC: FrameConduit
        
        init(document: Binding<StyledMarkdown>, frameC: FrameConduit) {
            self._document = document
            self.frameC = frameC
        }
        
        // TODO: use keyboard edits.
//        func textViewDidChange(_ textView: UITextView) {
//            text = textView.text
//        }
    }
}
