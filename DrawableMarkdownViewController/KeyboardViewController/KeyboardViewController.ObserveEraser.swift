//
//  KeyboardViewController.ObserveEraser.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 16/8/21.
//

import UIKit

extension KeyboardViewController {
    func observeEraser() {
        let eraser = PencilConduit.shared.$eraser
            .sink { [weak self] (point: CGPoint?) in
                switch point {
                case .none:
                    self?.erase()
                case .some(let point):
                    self?.add(point: point)
                }
            }
        store(eraser)
    }
    
    /// Mark the region around this point to this point to be erased.
    fileprivate func add(point: CGPoint) -> Void {
        
        var point = point
        
        /// Adjust point to text area coordinates.
        point.y -= textView.safeAreaInsets.top
        
        /// Add one line of height.
        point.y += UIFont.dynamicSize
        
        
//        binaryLineSearch(to: point)
        hitTestFragments(against: Circle(center: point, radius: PencilConduit.shared.eraserDiameter / 2))
        print("Non Contig \(textView.layoutManager.allowsNonContiguousLayout)")
        #warning("not implemented")
    }
    
    /// Erase marked regions.
    fileprivate func erase() -> Void {
        #warning("not implemented")
    }
    
    func hitTestFragments(against circle: Circle) {
        let fragments = textView.fragmentModel.fragments
        
        var topIntersectingLineFragment: Int? = fragments.firstIndex(where: {$0.rect.intersects(circle)})
        var bottomIntersectingLineFragment: Int? = fragments.lastIndex(where: {$0.rect.intersects(circle)})
        
        switch (topIntersectingLineFragment, bottomIntersectingLineFragment) {
        case (.some(let t), .some(let b)):
            (t...b).forEach { fragments[$0].test() }
        default:
            break
        }
        
        print(topIntersectingLineFragment, bottomIntersectingLineFragment)
        print(circle.center)
    }
    
    func binaryLineSearch(to point: CGPoint) -> Void {
        precondition(textView.text == coordinator.document?.markdown.plain, "Mismatched Text!")
        
        var point = point
        
        /// Adjust point to center rect.
        point.x -= PencilConduit.shared.eraserDiameter / 2
        point.y -= PencilConduit.shared.eraserDiameter / 2
        
        /// Adjust point to text area coordinates.
        point.y -= textView.safeAreaInsets.top
        
        /// Add one line of height to the rect.
        point.y -= UIFont.dynamicSize
        
        let lines = textView.getLines()
        
        let all = UITextView.Region(in: textView, start: textView.text.startIndex, end: textView.text.endIndex)
        print("All: \(all.rects())")
        print(textView.safeAreaInsets.top)
        
        let bounds = lines.getBounds(
            within: lines.startIndex..<lines.endIndex,
            intersecting: CGRect(
                origin: point,
                size: CGSize(
                    width: PencilConduit.shared.eraserDiameter,
                    /// Add one line of height to the rect.
                    height: PencilConduit.shared.eraserDiameter + UIFont.dynamicSize
                )
            )
        )
        
        print("Bounds: \(bounds)")
    }
}

extension UITextView {
    
    /// Split the ``text`` into one line regions,
    func getLines() -> [Region] {
        var lines: [Region] = []
        
        /// Start with the whole string.
        var substring: Substring = text[text.startIndex..<text.endIndex]
        
        while let s = substring.firstIndex(where: {$0.isNewline}) {
            lines.append(Region(in: self, start: substring.startIndex, end: s))
            
            /// Skip past the newline to the rest of the string
            substring = text[text.index(after: s)..<text.endIndex]
        }
        
        return lines
    }
    
    /// Represents a region of text in the text view.
    /// Most frequently represents a line or a few lines.
    struct Region {
        
        unowned var textView: UITextView
        let start: String.Index
        let end: String.Index
        
        init(in textView: UITextView, start: String.Index, end: String.Index) {
            self.textView = textView
            self.start = start
            self.end = end
        }
        
        /// The rectangles in the this `UITextRange`.
        func rects() -> [CGRect] {
            guard
                let start = textView.position(from: textView.beginningOfDocument, offset: start.utf16Offset(in: textView.text)),
                let end = textView.position(from: textView.beginningOfDocument, offset: end.utf16Offset(in: textView.text)),
                let range = textView.textRange(from: start, to: end)
            else {
                assert(false, "Failed to find range in line")
                return []
            }
            return textView.selectionRects(for: range).map { $0.rect }
        }
        
        /// Whether any the rectangles for this region intersect (on the y-axis) the givn rectangle.
        func intersectsY(_ rectangle: CGRect) -> Bool {
            rects()
                .map{ $0.intersectsY(of: rectangle) }
                .reduce(into: false, {$0 = $0||$1})
        }
    }
}

extension Array where Element == UITextView.Region {
    
    /// Find the range of lines within the provided sub-``range`` which intersect (on the y-axis) the given ``rect``.
    /// Uses binary search strategy to achieve `log(n)` time, where `n` is the number of lines (`range.count`).
    func getBounds(within range: Range<Index>, intersecting rect: CGRect) -> (high: Index, low: Index)? {
        guard isEmpty == false else { return nil }
        
        /// Unify lines in range.
        let lines = UITextView.Region(in: first!.textView, start: self[range.lowerBound].start, end: self[range.upperBound - 1].end)
        
        guard lines.intersectsY(rect) else {
            /// no intersection, nothing to contribute!
            return nil
        }

        /// nothing to split!
        if range.count == 1 {
            return (range.lowerBound, range.lowerBound)
        } else {
            /// Split range into top and bottom half
            let half: Int = range.count / 2
            
            /// Recursion! Use binary search strategy to discard either half if it does not intersect ``rect``.
            let t = getBounds(within: range.lowerBound..<(range.lowerBound + half), intersecting: rect)
            let b = getBounds(within: (range.lowerBound + half)..<range.upperBound, intersecting: rect)

            if case let (.some(t), .some(b)) = (t,b) {
                precondition(t.low + 1 == b.high, "Ranges don't touch! \(t), \(b)")

                /// merge ranges
                return (t.high, b.low)
            } else {
                /// Range was encompassed by only one half, or neither.
                /// Return whichever it was, if any.
                return t ?? b
            }
        }
    }
}

extension CGRect {
    func intersectsY(of other: CGRect) -> Bool {
        other.minY < maxY && other.maxY > minY
    }
}

extension UITextView {
    var allGlyphs: NSRange {
        NSMakeRange(0, layoutManager.numberOfGlyphs)
    }
}

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

struct Circle {
    let center: CGPoint
    let radius: CGFloat
    
    var bounds: CGRect {
        CGRect(origin: CGPoint(x: center.x - radius, y: center.y - radius), size: CGSize(width: 2 * radius, height: 2 * radius))
    }
}

extension CGRect {
    func intersects(_ circle: Circle) -> Bool {
        guard intersects(circle.bounds) else { return false }
        /// Checks if rectangle...
        
        /// Contains circle's center.
        return contains(circle.center)
            
            /// Between x-range, and within acceptable y-range.
            || ((minX <= circle.center.x && circle.center.x <= maxX) && (abs(minY - circle.center.y) <= circle.radius || abs(maxY - circle.center.y) <= circle.radius))
            
            /// Between y-range, and within acceptable x-range.
            || ((minY <= circle.center.y && circle.center.y <= maxY) && (abs(minX - circle.center.x) <= circle.radius || abs(maxX - circle.center.x) <= circle.radius))
        
            /// Within radius of each of the four corners.
            || CGPoint(x: minX, y: minY).within(circle.radius, of: circle.center)
            || CGPoint(x: minX, y: maxY).within(circle.radius, of: circle.center)
            || CGPoint(x: maxX, y: minY).within(circle.radius, of: circle.center)
            || CGPoint(x: maxX, y: maxY).within(circle.radius, of: circle.center)
    }
}

extension CGPoint {
    func within(_ threshold: CGFloat, of other: CGPoint) -> Bool {
        distance(to: other) <= threshold
    }
    
    func distance(to other: CGPoint) -> CGFloat {
        sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
}
