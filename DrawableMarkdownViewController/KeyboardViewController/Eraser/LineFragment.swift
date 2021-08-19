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
    
    func test(_ circle: Circle) {
        styleCharacters(intersecting: circle)
    }
    
    func styleCharacters(intersecting circle: Circle) {
        (glyphRange.lowerBound..<glyphRange.upperBound)
            .compactMap { characterRange(intersecting: circle, at: $0) }
            .forEach { textView.textStorage.addAttributes(Self.redText, range: $0) }
    }
    
    /// If the glyph at `glyphIndex` intersects `circle`, return its chracter range.
    func characterRange(intersecting circle: Circle, at glyphIndex: Int) -> NSRange? {
        let glyphRange = NSMakeRange(glyphIndex, 1)
        let glyphRect = textView.layoutManager.boundingRect(forGlyphRange: glyphRange, in: textView.textContainer)
        if glyphRect.intersects(circle) {
            return textView.layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        } else {
            return nil
        }
    }
        
    static let redText: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red]
}
