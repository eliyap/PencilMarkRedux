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
        switch stroke.interpret() {
        case .horizontalLine:
            strikethrough(with: stroke)
        case .wavyLine:
            print("Not Implemented!")
            break
        case .none:
            #warning("Todo: port code for red rejection")
            return
        }
    }
    
    func strikethrough(with stroke: PKStroke) -> Void {
        let (leading, trailing) = stroke.straightened()
        guard
            let uiStart = textView.closestPosition(to: leading),
            let uiEnd = textView.closestPosition(to: trailing),
            let range = textView.textRange(from: uiStart, to: uiEnd)
        else {
            print("Could not get path bounds!")
            return
        }
        
        
        let nsRange = textView.nsRange(from: range)
        coordinator.document.apply(lineStyle: Delete.self, to: nsRange)
        textView.attributedText = coordinator.document.styledText
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

