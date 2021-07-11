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
        textView.text = "Spicy jalapeno bacon ipsum dolor amet salami meatball venison filet mignon turducken. Cow ribeye pancetta prosciutto. Corned beef bacon alcatra beef frankfurter salami short ribs turkey kevin shank leberkas tongue venison. Picanha capicola brisket strip steak sausage bresaola beef ham hock alcatra tail turkey rump. Fatback kielbasa strip steak burgdoggen turducken shoulder beef. Sausage ham doner pastrami."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
