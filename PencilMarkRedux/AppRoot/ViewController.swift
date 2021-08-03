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
        
        let documentVC = FileBrowserViewController.DocumentDelegate(fileURL: nil)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Initiate `NSUserActivity` on appearance, which seems like the earliest point we may access the `windowScene`.
        if let scene = view.window?.windowScene {
            scene.userActivity = NSUserActivity(activityType: ActivityType.example.rawValue)
        } else {
            print("Todo: log missing scene!")
        }
    }
}
