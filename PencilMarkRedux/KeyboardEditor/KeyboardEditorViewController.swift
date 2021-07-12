//
//  KeyboardEditorViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import UIKit
import Combine
import PencilKit

final class KeyboardEditorViewController: UIViewController {
    let textView = UITextView()
    let strokeC: StrokeConduit
    let coordinator: KeyboardEditorView.Coordinator
    
    var observers = Set<AnyCancellable>()
    
    init(coordinator: KeyboardEditorView.Coordinator, strokeC: StrokeConduit) {
        self.strokeC = strokeC
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.view = textView
        
        textView.attributedText = coordinator.document.styledText
        textView.delegate = coordinator
        
        strokeC.$stroke
            .compactMap { $0 }
            .sink { [weak self] stroke in
                self?.test(stroke: stroke)
            }.store(in: &observers)
    }
    
    func test(stroke: PKStroke) -> Void {
        guard
            let cgStart = stroke.path.first?.location,
            let uiStart = textView.closestPosition(to: cgStart),
            let cgEnd = stroke.path.last?.location,
            let uiEnd = textView.closestPosition(to: cgEnd),
            let range = textView.textRange(from: uiStart, to: uiEnd)
        else {
            print("Could not get path bounds!")
            return
        }
        
        
        let nsRange = textView.nsRange(from: range)
        coordinator.document.apply(lineStyle: Delete.self, to: nsRange)
//        var text = textView.text!
//        text.replace(from: nsRange.upperBound, to: nsRange.upperBound, with: "~~")
//        text.replace(from: nsRange.lowerBound, to: nsRange.lowerBound, with: "~~")
//        textView.attributedText = styledMarkdown(from: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        /// Cancel Combine subscriptions to avoid memory leaks
        observers.forEach{ $0.cancel() }
        
        print("KeyboardEditorViewController de-initialized")
    }
}

func styledMarkdown(from markdown: String) -> NSMutableAttributedString {
    let mdast = Parser.shared.parse(markdown: markdown)
    var result = NSMutableAttributedString(string: markdown)
    mdast.style(&result)
    return result
}

extension UITextInput {
    func nsRange(from textRange: UITextRange) -> NSRange {
        let start = offset(from: beginningOfDocument, to: textRange.start)
        let end = offset(from: beginningOfDocument, to: textRange.end)
        return _NSRange(location: start, length: end - start)
    }
}
