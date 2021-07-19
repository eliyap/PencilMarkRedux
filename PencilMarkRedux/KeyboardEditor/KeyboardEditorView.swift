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
    let cmdC: CommandConduit
    @Binding var document: StyledMarkdown
    
    func makeUIViewController(context: Context) -> KeyboardEditorViewController {
        let vc = UIViewControllerType(coordinator: context.coordinator, strokeC: strokeC, frameC: frameC, cmdC: cmdC)
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
        
        /// Update model when user types.
        func textViewDidChange(_ textView: UITextView) {
            /// Update model text, but do not rebuild AST as that operation is expensive.
            document.text = textView.text
            
            /// Report via `Combine` that text did change.
            document.ticker.send()
        }
    }
}
