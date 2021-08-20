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
        point.x -= textView.textContainerInset.left
        
        /// Add one line of height.
        point.y += UIFont.dynamicSize
        
        hitTestFragments(against: Circle(center: point, radius: PencilConduit.shared.eraserDiameter / 2))
    }
    
    /// Erase marked regions.
    fileprivate func erase() -> Void {
        /// Update model, then report update, then update view.
        let ranges = textView.fragmentModel.getMergedRanges()
        
        guard ranges.isEmpty == false else { return }
        
        /// - Warning: Crashes the app if document is not already open!
        ///            Make sure this is not triggered on initial publication of ``PencilConduit``!
        registerUndo() /// register before model changes
        
        coordinator.document?.markdown.erase(ranges)
        coordinator.document?.updateChangeCount(.done)
        
        /// Set and style contents
        textView.text = coordinator.document?.markdown.plain
        coordinator.document?.markdown.updateAttributes()
        styleText()
        
        /// Discard model in light of updates.
        textView.fragmentModel.invalidate()
    }
    
    func hitTestFragments(against circle: Circle) {
        let fragments = textView.fragmentModel.fragments
        
        /// Find the sub-array of line fragments whose characters might intersect the circle.
        /// - Note: we assume this sub-array is a closed range that is continuous,
        ///         which rests on the assumption that the fragment array runs in one direction from top to bottom.
        let topIntersectingLineFragment: Int? = fragments.firstIndex(where: {$0.usedRect.intersectsY(circle)})
        let bottomIntersectingLineFragment: Int? = fragments.lastIndex(where: {$0.usedRect.intersectsY(circle)})
        
        switch (topIntersectingLineFragment, bottomIntersectingLineFragment) {
        case (.some(let t), .some(let b)):
            (t...b).forEach { fragments[$0].styleCharacters(intersecting: circle, with: LineFragment.redText) }
        case (.none, .none): /// out of bounds
            break
        case (.some, .none), (.none, .some):
            fatalError("Open Line Fragment Range!")
        }
    }
}
