//
//  LineFragment.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/8/21.
//

import UIKit

/**
 Represents one visual line in our ``UITextView``, which is distinct from a "line" as delineated by newline characters.
 Generated by method: https://developer.apple.com/documentation/uikit/nslayoutmanager/1403160-enumeratelinefragments
 */
final class LineFragment {
    
    /// A structure for looking up the bounding rectangle of each glyph in this line fragment.
    /// - Key: the glyph index in ``textView``.
    /// - Value: the bounding rectangle around that glyph.
    typealias GlyphTable = [Int: CGRect]
    
    /// A style we can apply to an `NSAttributedString`.
    typealias Style = [NSAttributedString.Key: Any]
        
    public static let redText: Style = [.foregroundColor: UIColor.red]
    
    /// Line fragment rectangle.
    public let rect: CGRect
    
    /// The portion of the line fragment rectangle that actually contains glyphs or other marks that are drawn
    /// (including the text container’s line fragment padding).
    public let usedRect: CGRect
    
    /// The text view in which the glyphs are laid out.
    private unowned let textView: UITextView
    
    /// The range of glyphs laid out in the current line fragment.
    public let glyphRange: NSRange
    
    /// For performance reasons, we try to avoid generating this data at all,
    /// and always avoid generate it at most once (until the model is invalidated) using memoization.
    private var _glyphRects: GlyphTable? = nil
    private var glyphRects: GlyphTable {
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
    
    /// Character ranges that have already been styled.
    /// - Warning: assumes only one temporary style is being applied at once!
    /// - Warning: assumes each range represents a single / glyph or character, and does not attempt to do any intersecting!
    private var styledRanges: Set<NSRange> = Set([])
    
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
    
    public func styleCharacters(intersecting circle: Circle) {
        glyphRects.keys
            .compactMap { characterRange(intersecting: circle, at: $0) }
            .compactMap {
                if styledRanges.contains($0) {
                    return nil
                } else {
                    styledRanges.insert($0)
                    return $0
                }
            }
            .forEach { textView.textStorage.addAttributes(Self.redText, range: $0) }
    }
    
    /// If the glyph at `glyphIndex` intersects `circle`, return its chracter range.
    private func characterRange(intersecting circle: Circle, at glyphIndex: Int) -> NSRange? {
        let glyphRect = glyphRects[glyphIndex]!
        
        #if DEBUG /// validate memoized values
        check(rect: glyphRect, at: glyphIndex)
        #endif
        
        if glyphRect.intersects(circle) {
            return textView.layoutManager.characterRange(forGlyphRange: NSMakeRange(glyphIndex, 1), actualGlyphRange: nil)
        } else {
            return nil
        }
    }
    
    /// Debugging check, seeing if the memoized and actual values are consistent.
    fileprivate func check(rect: CGRect, at glyphIndex: Int) {
        let range = NSMakeRange(glyphIndex, 1)
        let r = textView.layoutManager.boundingRect(forGlyphRange: range, in: textView.textContainer)
        assert(r.width == rect.width)
        assert(r.height == rect.height)
        assert(r.origin.x == rect.origin.x)
        if r.origin.x != rect.origin.x {
            print("Y Diff: \(r.origin.y - rect.origin.y)")
        }
    }
    
    /// Get the bounding rectangles for each glyph in this line fragment.
    /// Results should be memo-ized so we don't need to call this expensive operation often.
    private func findGlyphRects() -> GlyphTable {
        var table: GlyphTable = [:]
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
}
