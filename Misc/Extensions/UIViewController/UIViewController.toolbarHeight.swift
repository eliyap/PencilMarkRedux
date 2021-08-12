//
//  UIViewController.toolbarHeight.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import UIKit

/// Shorthand to find various inset heights
extension UIViewController {
    var toolbarHeight: CGFloat? { navigationController?.toolbar.frame.height }
    
    /// - Note: call this on own view controller, not `navigationController`!
    var navBarHeight: CGFloat? { navigationController?.navigationBar.frame.height }
    
    var statusBarHeight: CGFloat? { UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.windowScene?.statusBarManager?.statusBarFrame.height }
}
