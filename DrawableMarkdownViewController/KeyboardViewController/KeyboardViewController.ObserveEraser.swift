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
        binaryLineSearch(to: point)
        #warning("not implemented")
    }
    
    /// Erase marked regions.
    fileprivate func erase() -> Void {
        #warning("not implemented")
    }
    
    func binaryLineSearch(to point: CGPoint) -> Void {
        precondition(textView.text == coordinator.document?.markdown.plain, "Mismatched Text!")
        
        let lines = textView.getLines()
        let bounds = lines.getBounds(
            within: lines.startIndex..<lines.endIndex,
            intersecting: CGRect(
                origin: point,
                size: CGSize(
                    width: PencilConduit.shared.eraserDiameter,
                    height: PencilConduit.shared.eraserDiameter
                )
            )
        )
        
        print("Bounds: \(bounds)")
    }
}

extension UITextView {
    
    func getLines() -> [Line] {
        var lines: [Line] = []
        
        /// Start with the whole string.
        var substring: Substring = text[text.startIndex..<text.endIndex]
        
        while let s = substring.firstIndex(where: {$0.isNewline}) {
            lines.append(Line(in: self, start: substring.startIndex, end: s))
            
            /// Skip past the newline to the rest of the string
            substring = text[text.index(after: s)..<text.endIndex]
        }
        
        return lines
    }
    
    /// Represents a line of text in the text view.
    struct Line {
        
        unowned var textView: UITextView
        let start: String.Index
        let end: String.Index
        
        init(in textView: UITextView, start: String.Index, end: String.Index) {
            self.textView = textView
            self.start = start
            self.end = end
        }
        
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
        
        /// Whether the bounding rectangle for this region
        func intersectsY(_ rectangle: CGRect) -> Bool {
            rects()
                .map{ $0.intersectsY(of: rectangle) }
                .reduce(into: false, {$0 = $0||$1})
        }
    }
}

extension Array where Element == UITextView.Line {
    
    func getBounds(within range: Range<Index>, intersecting rect: CGRect) -> (high: Index, low: Index)? {
        guard isEmpty == false else { return nil }
        
        /// Unify lines in range.
        let lines = UITextView.Line(in: first!.textView, start: self[range.lowerBound].start, end: self[range.upperBound - 1].end)
        
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
