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
        #warning("not implemented")
    }
    
    /// Erase marked regions.
    fileprivate func erase() -> Void {
        #warning("not implemented")
    }
}
