//
//  LineFragment.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/8/21.
//

import UIKit

final class LineFragment {
    /// Line fragment rectangle.
    let rect: CGRect
    
    /// The portion of the line fragment rectangle that actually contains glyphs or other marks that are drawn
    /// (including the text container’s line fragment padding).
    let usedRect: CGRect
    
    /// The text container in which the glyphs are laid out.
    unowned let textView: UITextView
    
    /// The range of glyphs laid out in the current line fragment.
    let glyphRange: NSRange
    
    private var _glyphRects: [Int: CGRect]? = nil
    private var glyphRects: [Int: CGRect] {
        get {
            if let g = _glyphRects {
                return g
            } else {
                let g = findGlyphRects()
                _glyphRects = g
                return g
            }
            
        }
    }
    
    init(
        rect: CGRect,
        usedRect: CGRect,
        textView: UITextView,
        glyphRange: NSRange
    ) {
        self.rect = rect
        self.usedRect = usedRect
        self.textView = textView
        self.glyphRange = glyphRange
    }
    
    func test(_ circle: Circle) {
        styleCharacters(intersecting: circle)
    }
    
    func styleCharacters(intersecting circle: Circle) {
        glyphRects.keys
            .compactMap { characterRange(intersecting: circle, at: $0) }
            .forEach { textView.textStorage.addAttributes(Self.redText, range: $0) }
    }
    
    /// If the glyph at `glyphIndex` intersects `circle`, return its chracter range.
    func characterRange(intersecting circle: Circle, at glyphIndex: Int) -> NSRange? {
        if glyphRects[glyphIndex]!.intersects(circle) {
            return textView.layoutManager.characterRange(forGlyphRange: NSMakeRange(glyphIndex, 1), actualGlyphRange: nil)
        } else {
            return nil
        }
    }
    
    /// Get the bounding rectangles for each glyph in this line fragment.
    /// Results should be memo-ized so we don't need to call this expensive operation often.
    private func findGlyphRects() -> [Int: CGRect] {
        var table: [Int: CGRect] = [:]
        for glyphIndex in (glyphRange.lowerBound..<glyphRange.upperBound) {
            let glyphRange = NSMakeRange(glyphIndex, 1)
            let glyphRect = textView.layoutManager.boundingRect(forGlyphRange: glyphRange, in: textView.textContainer)
            table[glyphIndex] = glyphRect
        }
        return table
    }
    
    /// - Note: may be irrelevant anyway.
    public func invalidate() -> Void {
        _glyphRects = nil
    }
        
    static let redText: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red]
}
