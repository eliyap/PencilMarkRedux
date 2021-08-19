//
//  UITextView.allGlyphs.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/8/21.
//

import UIKit

extension UITextView {
    /// Convenience property
    var allGlyphs: NSRange {
        NSMakeRange(0, layoutManager.numberOfGlyphs)
    }
}
