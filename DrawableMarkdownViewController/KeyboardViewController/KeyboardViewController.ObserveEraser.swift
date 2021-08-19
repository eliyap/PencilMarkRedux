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
        print("Non Contig \(textView.layoutManager.allowsNonContiguousLayout)")
        #warning("not implemented")
    }
    
    /// Erase marked regions.
    fileprivate func erase() -> Void {
        /// Reset formatting
        styleText()
    }
    
    func hitTestFragments(against circle: Circle) {
        let fragments = textView.fragmentModel.fragments
        
        var topIntersectingLineFragment: Int? = fragments.firstIndex(where: {$0.rect.intersects(circle)})
        var bottomIntersectingLineFragment: Int? = fragments.lastIndex(where: {$0.rect.intersects(circle)})
        
        switch (topIntersectingLineFragment, bottomIntersectingLineFragment) {
        case (.some(let t), .some(let b)):
            (t...b).forEach { fragments[$0].test(circle) }
        default:
            break
        }
        
        print(topIntersectingLineFragment, bottomIntersectingLineFragment)
        print(circle.center)
    }
}
