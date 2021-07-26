//
//  UITextRange_NSRange.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation
import UIKit

extension UITextInput {
    func nsRange(from textRange: UITextRange) -> NSRange {
        let start = offset(from: beginningOfDocument, to: textRange.start)
        let end = offset(from: beginningOfDocument, to: textRange.end)
        return NSMakeRange(start, end - start)
    }
}
