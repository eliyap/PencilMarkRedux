//
//  FragmentModel.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/8/21.
//

import UIKit

final class FragmentModel {
    /**
     Line fragments in the `PMTextView`.
     If none are available, generate them!
     */
    private var _fragments: [LineFragment]? = nil
    public var fragments: [LineFragment] {
        get {
            if let f = _fragments {
                return f
            } else {
                let new = getFragments()
                _fragments = new
                return new
            }
        }
    }
    
    unowned let textView: PMTextView
    
    init(textView: PMTextView){
        self.textView = textView
    }
    
    /// Notify us that the text has changed and our fragments are out of date.
    public func invalidate() {
        _fragments = nil
    }
    
    private func getFragments() -> [LineFragment] {
        var fragments: [LineFragment] = []
        
        /// The rect most recently passed to us in `block`.
        var lastRect: CGRect? = nil
        
        /// Closure passed into `enumerateLineFragments`
        func block(
            rect: CGRect,
            usedRect: CGRect,
            textContainter: NSTextContainer,
            glyphRange: NSRange,
            stop: UnsafeMutablePointer<ObjCBool>
        ) -> Void {
            /// Update most recent rect.
            defer { lastRect = rect }
            
            /// Validate assumption that closure runs from top to bottom of document.
            precondition((lastRect?.origin.y ?? -.infinity) < rect.origin.y, "Last rect was below this rect! \(lastRect ?? .zero), \(rect)")
            
            fragments.append(LineFragment(rect: rect, usedRect: usedRect, textView: textView, glyphRange: glyphRange))
        }
        
        /// Invoke with block
        textView.layoutManager.enumerateLineFragments(forGlyphRange: textView.allGlyphs, using: block)
        
        return fragments
    }
}

extension FragmentModel {
    public func getMergedRanges() -> [NSRange] {
        merge(getStyledRanges())
    }
    
    /// Find all styled ranges in fragments.
    private func getStyledRanges() -> [NSRange] {
        fragments
            .map { $0.styledRanges }
            .reduce([], +)
    }
    
    /// A mutable analogue to `NSRange`.
    fileprivate struct MutableRange {
        var lowerBound: Int
        var upperBound: Int
        var length: Int { upperBound - lowerBound }
        
        /// Creates an identical `NSRange`.
        var nsRange: NSRange { NSMakeRange(lowerBound, length) }
    }
    
    private func merge(_ ranges: [NSRange]) -> [NSRange] {
        guard ranges.isEmpty == false else { return [] }
        
        let ranges = ranges.sorted { $0.lowerBound < $1.lowerBound }
        
        var result: [NSRange] = []
        
        var temp = MutableRange(lowerBound: ranges[0].lowerBound, upperBound: ranges[0].upperBound)
        for range in ranges[1...] {
            switch (temp.upperBound, range.lowerBound) {
            case let (x, y) where x == y:
                /// Ranges are contiguous, so merge them by bumping the bounds.
                temp.upperBound = range.upperBound
            
            case let (x, y) where x < y:
                /// Ranges are non-contiguous, so break away to make a new range.
                result.append(temp.nsRange)
                temp = MutableRange(lowerBound: range.lowerBound, upperBound: range.upperBound)
            
            case let (x, y) where x > y:
                fatalError("Overlapping Ranges \(temp) and \(range)")
            
            default:
                fatalError("Impossible Case!")
            }
        }
        
        /// Insert final range.
        result.append(temp.nsRange)
        
        return result
        /// we have an upper bound
        /// if the upper bound is nil, we just started, make a new range
        /// if the upper bound is our lower bound, extend the range
        /// if the upper bound is less than our lower bound, store the range and make a new one
        /// if the upper bound is greater, fatal error.
    }
}
