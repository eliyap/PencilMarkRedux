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
    let files: FilesViewController
    let empty = RefreshablePlaceholderViewController<EmptyFolderHost, EmptyFolderView>() /// placeholder for empty folder
    let broken = RefreshablePlaceholderViewController<iCloudBrokenHost, iCloudBrokenView>() /// placeholder when iCloud can't be accessed
    
    /// Be aware of iCloud URL
    let iCloudURL: URL? = FileManager.default.url(forUbiquityContainerIdentifier: nil)?
        .appendingPathComponent("Documents")
    
    init(url: URL?, selectionDelegate: FileBrowserViewController.DocumentDelegate) {
        self.url = url
        self.selectionDelegate = selectionDelegate
        self.files = FilesViewController(url: url, selectionDelegate: selectionDelegate)
        super.init(nibName: nil, bundle: nil)
        files.folder = self /// *must* set implicitly unwrapped reference immediately
        
        /// Add subviews into hierarchy.
        adopt(files)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    /// Update `SwiftUI` constraints when view appears.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        files.view.frame = view.frame
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
            view.bringSubviewToFront(files.view)
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
            let newDocBtn = UIBarButtonItem.menuButton(self, action: #selector(newDocument), imageName: "document")
            newDocBtn.tintColor = tint

            let newFolderBtn = UIBarButtonItem.menuButton(self, action: #selector(newFolder), imageName: "folder")            
            newFolderBtn.tintColor = tint
            
            return (super.toolbarItems ?? []) + [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                newFolderBtn,
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
        
        let fileURL: URL = newURL(in: url, base: "Untitled", suffix: ".txt")
        
        /// Assign document location and empty contents
        let document = StyledMarkdownDocument(fileURL: fileURL)
        document.markdown = Markdown("")
        
        /// Write to disk
        document.save(to: fileURL, for: .forCreating) { (success) in
            guard success else {
                assert(false, "Failed to create document!")
                return
            }
            
            /// Animate row insertion
            self.files.filesView.reveal(IndexPath(
                row: self.files.contents!.firstIndex(of: fileURL)!,
                section: 0
            ))
            
            /// Open Document In Editor
            self.selectionDelegate.present(fileURL: fileURL)
        }
    }
    
    @objc
    private func newFolder() {
        guard let url = url else {
            assert(false, "New Document Cannot Be Created In Null Folder!")
            return
        }
        
        let folderURL: URL = newURL(in: url, base: "Untitled Folder", suffix: "")
        precondition(FileManager.default.fileExists(atPath: folderURL.path) == false, "File already exists at URL \(url)")
        
        do {
            /// Should never need to create intermediate directories.
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: false, attributes: nil)
            
            /// Get index of ".../MyFolder" or ".../MyFolder/"
            let index: Int? = self.files.contents!.firstIndex(of: folderURL)
                ?? self.files.contents!.firstIndex(of: folderURL.appendingPathComponent("/"))
            
            /// Animate row insertion
            self.files.filesView.reveal(IndexPath(
                row: index!,
                section: 0
            ))
        } catch {
            assert(false, "Failed to create folder!")
            return
        }
    }
}
