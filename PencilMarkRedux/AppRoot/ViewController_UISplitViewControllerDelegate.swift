//
//  ViewController_UISplitViewControllerDelegate.swift
//  ViewController_UISplitViewControllerDelegate
//
//  Created by Secret Asian Man Dev on 1/8/21.
//

import UIKit

extension ViewController: UISplitViewControllerDelegate {
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        /// Nothing
    }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        /// Nothing
    }
    
    /// Prefer secondary view controller in compact width.
    /// This allows the user to keep editing the document.
    /// Docs: https://developer.apple.com/documentation/uikit/uisplitviewcontrollerdelegate/3580925-splitviewcontroller
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        /// Collapse to document if one is open, otherwise collapse to the document picker.
        if documentDelegate.document == nil {
            return .primary
        } else {
            return .secondary
        }
    }
    
    func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
        /// Nothing
    }
    
    func splitViewControllerDidExpand(_ svc: UISplitViewController) {
        /// Nothing
    }
    
    func splitViewController(_ svc: UISplitViewController, willHide column: UISplitViewController.Column) {
        /// Nothing
    }
    
    func splitViewController(_ svc: UISplitViewController, willShow column: UISplitViewController.Column) {
        if column == .primary {
            /// request an extra layout pass
            SplitConduit.shared.needLayoutKeyboard = true
        }
    }
}
