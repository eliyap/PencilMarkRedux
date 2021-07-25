//
//  UIViewController.toolbarHeight.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import UIKit

extension UIViewController {
    /// Shorthand to find the toolbar's height
    var toolbarHeight: CGFloat? { navigationController?.toolbar.frame.height }
    
    var navBarHeight: CGFloat? { navigationController?.navigationBar.frame.height }
}
