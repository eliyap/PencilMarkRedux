//
//  UIViewController.adopt.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Foundation
import UIKit

extension UIViewController {
    /// Convenience method for adding a subview to the view hierarchy.
    func adopt(_ child: ViewController) {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
