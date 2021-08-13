//
//  ViewController_UISplitViewControllerDelegate.swift
//  ViewController_UISplitViewControllerDelegate
//
//  Created by Secret Asian Man Dev on 1/8/21.
//

import UIKit

extension ViewController: UISplitViewControllerDelegate {
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
//        print("Swipey")
    }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
//        print("New Mode: \(displayMode.rawValue), \(svc.preferredDisplayMode.rawValue)")
//        print("Behaviour: \(svc.splitBehavior.rawValue), \(svc.preferredSplitBehavior.rawValue)")
    }
    
    /// Prefer primary view controller in compact width.
    /// Docs: https://developer.apple.com/documentation/uikit/uisplitviewcontrollerdelegate/3580925-splitviewcontroller
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        .primary
    }
    
    func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
//        print("Split Controller Did Collapse")
    }
    
    func splitViewControllerDidExpand(_ svc: UISplitViewController) {
//        print("Split Controller Did Expand")
    }
    
    func splitViewController(_ svc: UISplitViewController, willHide column: UISplitViewController.Column) {
        if column == .primary {
            SplitConduit.shared.primaryColumnChange.send()
        }
    }
    
    func splitViewController(_ svc: UISplitViewController, willShow column: UISplitViewController.Column) {
        if column == .primary {
            SplitConduit.shared.primaryColumnChange.send()
        }
    }
}
