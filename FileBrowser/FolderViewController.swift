//
//  FolderViewController.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 22/7/21.
//

import Foundation
import UIKit
import PMAST

/**
 Wraps ``FilesViewController`` so that if the folder is empty,
 we can stick a pretty placeholder in front to indicate that instead of just having an empty table.
 
 - Note: this handles the `UINavigationController` `toolbar`
    - known issue: toolbar does not adjust for the keyboard. I couldn't get it to work correctly, and it's not _that_ important.
 */
final class FolderViewController: UIViewController {
    
    /// Folder URL
    let url: URL?
    
    /// Allow direct access to set document on detail ViewController.
    weak var selectionDelegate: FileBrowserViewController.DocumentDelegate!
    
    /// Subviews
    let filesView: FilesViewController
    let empty = RefreshablePlaceholderViewController<EmptyFolderHost, EmptyFolderView>() /// placeholder for empty folder
    let broken = RefreshablePlaceholderViewController<iCloudBrokenHost, iCloudBrokenView>() /// placeholder when iCloud can't be accessed
    
    /// Be aware of iCloud URL
    let iCloudURL: URL? = FileManager.default.url(forUbiquityContainerIdentifier: nil)?
        .appendingPathComponent("Documents")
    
    init(url: URL?, selectionDelegate: FileBrowserViewController.DocumentDelegate) {
        self.url = url
        self.selectionDelegate = selectionDelegate
        self.filesView = FilesViewController(url: url, selectionDelegate: selectionDelegate)
        super.init(nibName: nil, bundle: nil)
        filesView.folder = self /// *must* set implicitly unwrapped reference immediately
        
        /// Add subviews into hierarchy.
        adopt(filesView)
        adopt(empty)
        adopt(broken)
        
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
        guard let url = url else {
            assert(false, "New Document Cannot Be Created In Null Folder!")
            return
        }
        
        let fileURL: URL = newDocumentURL(in: url)
        
        /// Assign document location and empty contents
        let document = StyledMarkdownDocument(fileURL: fileURL)
        document.markdown = Markdown("")
        
        /// Write to disk
        document.save(to: fileURL, for: .forCreating) { (success) in
            guard success else {
                assert(false, "Failed to create document!")
                return
            }
            
            /// Refresh UITableView
            /// TODO: make table view scroll to new document...
            self.filesView.tableView.reloadData()
            
            /// Open Document In Editor
            self.selectionDelegate.present(fileURL: fileURL)
        }
        print("Not Implemented")
    }
}
