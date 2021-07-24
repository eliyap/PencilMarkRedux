//
//  ViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import Foundation
import UIKit

final class ViewController: UISplitViewController {

    var iCloudURL: URL? {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)?
            .appendingPathComponent("Documents")
    }
    
    required init?(coder: NSCoder) {
        super.init(style: .doubleColumn)
        
        /// Pretty bad system, needs to be redone
        let documentVC = DocumentViewController(url: iCloudURL ?? documentsURL)
        setViewController(documentVC, for: .secondary)
        
        /// File Browser
        let browserVC = FileBrowserViewController(selectionDelegate: documentVC)
        setViewController(browserVC, for: .primary)
        
        /// Set preferred layout style
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
        presentsWithGesture = true
        
        /// Set delegate
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        // Do any additional setup after loading the view.
    }
}


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
}
