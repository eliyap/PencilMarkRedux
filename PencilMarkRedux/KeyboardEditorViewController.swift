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
    
    var observers = Set<AnyCancellable>()
    
    init(strokeC: StrokeConduit) {
        self.strokeC = strokeC
        super.init(nibName: nil, bundle: nil)
        self.view = textView
        textView.text = "Spicy jalapeno bacon ipsum dolor amet salami meatball venison filet mignon turducken. Cow ribeye pancetta prosciutto. Corned beef bacon alcatra beef frankfurter salami short ribs turkey kevin shank leberkas tongue venison. Picanha capicola brisket strip steak sausage bresaola beef ham hock alcatra tail turkey rump. Fatback kielbasa strip steak burgdoggen turducken shoulder beef. Sausage ham doner pastrami."
        
        strokeC.$stroke
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
    
        print(textView.text(in: range) ?? "No Text" )
        
        
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
