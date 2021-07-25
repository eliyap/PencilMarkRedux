//
//  FolderViewController.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 22/7/21.
//

import Foundation
import UIKit

/**
 Wraps ``FilesViewController`` so that if the folder is empty,
 we can stick a pretty placeholder in front to indicate that instead of just having an empty table.
 */
final class FolderViewController: UIViewController {
    
    let url: URL?
    
    /// Allow direct access to set document on detail ViewController.
    weak var selectionDelegate: FileBrowserViewController.DocumentDelegate!
    
    /// Subviews
    let filesView: FilesViewController
    let empty = EmptyFolderHost() /// placeholder for empty folder
    let broken = iCloudBrokenHost() /// placeholder when iCloud can't be accessed
    
    /// Be aware of iCloud URL
    let iCloudURL: URL? = FileManager.default.url(forUbiquityContainerIdentifier: nil)?
        .appendingPathComponent("Documents")
    
    init(url: URL?, selectionDelegate: FileBrowserViewController.DocumentDelegate) {
        self.url = url
        self.selectionDelegate = selectionDelegate
        self.filesView = FilesViewController(url: url, selectionDelegate: selectionDelegate)
        super.init(nibName: nil, bundle: nil)
        filesView.folder = self /// *must* set implicitly unwrapped reference immediately
        
        /// Set up scroll view so that we can use `UIRefreshControl`.
        let scrollView = UIScrollView()
        self.view = scrollView
        
        /// Allow scrolling even when content is too small (i.e. when SwiftUI View is shown).
        scrollView.alwaysBounceVertical = true
        
        /// Add subviews into hierarchy.
        adopt(filesView)
        adopt(empty)
        adopt(broken)
        
        /// Refresh on pull.
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(filesView, action: #selector(FilesViewController.refresh), for: .valueChanged)
        
        /// Make area behind `scrollView` seamless with the `scollView` itself.
        view.backgroundColor = .systemBackground
        
        /// Set nav bar title to folder name
        if iCloudURL != nil && url == iCloudURL {
            navigationItem.title = "iCloud Drive" /// special title, replaces "Documents"
        } else {
            navigationItem.title = url?.lastPathComponent ?? "" /// empty title if folder is unreachable
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Show toolbar
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    /// Update `SwiftUI` constraints when view appears.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        filesView.view.frame = view.frame
        empty.view.frame = view.frame
        broken.view.frame = view.frame
        
        /// Note: do **not** set frame for all subviews, as this breaks the refresh indicator layout for `UIRefreshController`.
    }
}

// MARK:- Error Views
extension FolderViewController {
    enum FolderState {
        case ok /// nothing wrong, show contained files in `UITableView`
        case empty /// folder has no contents, show a nice placeholder
        case inaccessible /// folder URL could not be resolved, expose the problem to the user
    }
    
    /// Surface the appropriate view for the problem.
    public func show(_ folderState: FolderState) -> Void {
        switch folderState {
        case .ok:
            view.bringSubviewToFront(filesView.view)
        case .empty:
            view.bringSubviewToFront(empty.view)
        case .inaccessible:
            view.bringSubviewToFront(broken.view)
        }
    }
}

// MARK:- Toolbar Items
extension FolderViewController {

    override var toolbarItems: [UIBarButtonItem]? {
        get {
            let newDocBtn = UIBarButtonItem(image: UIImage(systemName: "doc.badge.plus"), style: .plain, target: self, action: #selector(newDocument))
            newDocBtn.tintColor = tint
            
            return (super.toolbarItems ?? []) + [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                newDocBtn,
            ]
        }
        set {
            fatalError("Tried to modify toolbarItems!")
        }
    }

    @objc
    private func newDocument() {
        /// TODO: check that folder URL is non null!, folder state is not broken
        
        #warning("New Document Not Implemented")
        print("Not Implemented")
    }
}
