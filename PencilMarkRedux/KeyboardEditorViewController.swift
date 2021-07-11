//
//  KeyboardEditorViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import UIKit

final class KeyboardEditorViewController: UIViewController {
    let textView = UITextView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view = textView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
