//
//  KeyboardViewController.ObserveEraser.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 16/8/21.
//

import UIKit
import PMAST

extension KeyboardViewController {
    func observeEraser() {
        let eraser = PencilConduit.shared.$location
            .compactMap { $0 } /// Ignore  initial`nil`.
            .sink { [weak self] (location: (point: CGPoint?, tool: Tool)) in
                switch location.tool {
                case .eraser:
                    switch location.point {
                    case .none:
                        self?.erase()
                    case .some(let point):
                        self?.add(point: point, tool: .eraser)
                    }
                #if HIGHLIGHT_ENABLED
                case .highlighter:
                    #warning("TODO: Program Highlighter!")
                    switch location.point {
                    case .none:
                        self?.highlight()
                    case .some(let point):
                        self?.add(point: point, tool: .highlighter)
                    }
                #endif
                default:
                    assert(false, "Unhandled Tool!")
                    break
                }
            }
        store(eraser)
    }
    
    /// Mark the region around this point to this point to be erased.
    fileprivate func add(point: CGPoint, tool: Tool) -> Void {
        
        /// Update state variable.
        eraserDown = true
        
        var point = point
        
        /// Adjust point to text area coordinates.
        point.x -= textView.textContainerInset.left
        
        hitTestFragments(
            against: Circle(center: point, radius: PencilConduit.shared.eraserDiameter / 2),
            tool: tool
        )
    }
    
    /// Erase marked regions.
    fileprivate func erase() -> Void {
        /// Reset model state.
        defer {
            /// Update state variable.
            eraserDown = false
            
            /// Discard model in light of updates.
            textView.fragmentModel.invalidate()
        }
        
        /// Update model, then report update, then update view.
        let ranges = textView.fragmentModel.getMergedRanges()
        
        guard ranges.isEmpty == false else { return }
        
        /// - Warning: Crashes the app if document is not already open!
        ///            Make sure this is not triggered on initial publication of ``PencilConduit``!
        registerUndo(restyle: true) /// register before model changes
        
        model.document?.markdown.erase(ranges)
        model.document?.updateChangeCount(.done)
        
        /// Set and style contents
        textView.text = model.document?.markdown.plain
        styleText() /// Note: tree is patched `markdown.apply` call.
    }
    
    /// Highlight marked regions.
    fileprivate func highlight() -> Void {
        /// Reset model state.
        defer {
            /// Update state variable.
            eraserDown = false
            
            /// Discard model in light of updates.
            textView.fragmentModel.invalidate()
        }
        
        /// Update model, then report update, then update view.
        let ranges = textView.fragmentModel.getMergedRanges()
        
        guard ranges.isEmpty == false else { return }
        
        /// - Warning: Crashes the app if document is not already open!
        ///            Make sure this is not triggered on initial publication of ``PencilConduit``!
        registerUndo(restyle: true) /// register before model changes
        
        model.document?.markdown.apply(lineStyle: Mark.self, to: ranges)
        model.document?.updateChangeCount(.done)
        
        /// Set and style contents
        textView.text = model.document?.markdown.plain
        styleText() /// Note: tree is patched `markdown.apply` call.
    }
    
    func hitTestFragments(against circle: Circle, tool: Tool) {
        let fragments = textView.fragmentModel.fragments
        
        /// Find the sub-array of line fragments whose characters might intersect the circle.
        /// - Note: we assume this sub-array is a closed range that is continuous,
        ///         which rests on the assumption that the fragment array runs in one direction from top to bottom.
        let topIntersectingLineFragment: Int? = fragments.firstIndex(where: {$0.usedRect.intersectsY(circle)})
        let bottomIntersectingLineFragment: Int? = fragments.lastIndex(where: {$0.usedRect.intersectsY(circle)})
        
        
        
        switch (topIntersectingLineFragment, bottomIntersectingLineFragment) {
        case (.some(let t), .some(let b)):
            (t...b).forEach { fragments[$0].styleCharacters(intersecting: circle, with: tool.style) }
        case (.none, .none): /// out of bounds
            break
        case (.some, .none), (.none, .some):
            fatalError("Open Line Fragment Range!")
        }
    }
}
