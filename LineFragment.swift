//
//  LineFragment.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/8/21.
//

import UIKit

struct LineFragment {
    /// Line fragment rectangle.
    let rect: CGRect
    
    /// The portion of the line fragment rectangle that actually contains glyphs or other marks that are drawn
    /// (including the text container’s line fragment padding).
    let usedRect: CGRect
    
    /// The text container in which the glyphs are laid out.
    unowned let textView: UITextView
    
    /// The range of glyphs laid out in the current line fragment.
    let glyphRange: NSRange
    
    func test() {
        for i in glyphRange.lowerBound..<glyphRange.upperBound {
            textView.layoutManager.boundingRect(forGlyphRange: NSMakeRange(i, 1), in: textView.textContainer)
        }
    }
}
