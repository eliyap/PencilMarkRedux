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
