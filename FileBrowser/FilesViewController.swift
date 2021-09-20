//
//  FilesViewController.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 20/7/21.
//

import Foundation
import UIKit

/**
 Given a URL to a folder in the iCloud Drive, show the contents.
 */
class FilesViewController: UITableViewController {
    
    let url: URL?
    
    /// Allow direct access to set document on detail ViewController.
    weak var selectionDelegate: FileBrowser.ViewController.DocumentDelegate!
    
    /// Allows us to bring error views to the front.
    weak var folder: FolderViewController!
    
    /// A cache of files previously seen in this folder.
    var _cachedContents: [URL] = []
    
    /// Alias for `tableView` with known type.
    let filesView = FilesView()
    
    /// Latch variable to ensure state restoration is triggered only once.
    var shouldRestore: Bool
    
    init(url: URL?, selectionDelegate: FileBrowser.ViewController.DocumentDelegate, shouldRestore: Bool = false) {
        self.url = url
        self.selectionDelegate = selectionDelegate
        self.shouldRestore = shouldRestore
        super.init(style: .plain)
       
        /// Attach custom `UITableView`
        self.tableView = filesView
        
        tableView.register(FilesViewCell.self, forCellReuseIdentifier: FilesViewCell.identifier)
        
        /// Attach refresh controller
        configureRefresh()
        
        /// Adjust for keyboard
        setupNotifications()
        
        /// Attach custom data source.
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = .tableBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreState()
    }
    
    fileprivate func restoreState() -> Void {
        /// Only restore once, and only after the model is ready.
        guard shouldRestore, StateModel.shared.restored else { return }
        shouldRestore = false
        
        guard let stateURL = StateModel.shared.url else { return }
        guard let folderURL = self.url else {
            return
        }
        if let end = stateURL.relativeString.ranges(of: folderURL.relativeString).first?.upperBound {
            let components = stateURL.relativeString[end...].split(separator: "/")
            guard
                let contents = contents,
                let firstComponent = components.first,
                let first = String(firstComponent).removingPercentEncoding
            else {
                SceneRestoration.print("Could Not Get Folder Contents!")
                return
            }
            
            let nextURL = folderURL.appendingPathComponent(first)
            guard let idx = contents.firstIndex(of: nextURL) else {
                SceneRestoration.print("""
                    Could Not Get Index!
                    - Next: \(nextURL)
                    - Cont: \(contents)
                    """)
                return
            }
            
            if components.count > 1 {
                precondition(nextURL.isDirectory, "Path Components Found In Non Directory!")
                let vc = FolderViewController(url: nextURL, selectionDelegate: selectionDelegate, shouldRestore: true)
                navigationController?.pushViewController(vc, animated: false)
            } else if components.count == 1 {
                precondition(nextURL.isFileURL, "Expected FileURL!")
                tableView.selectRow(at: IndexPath(row: idx, section: 0), animated: false, scrollPosition: .none)
            } else {
                assert(false, "No Trailing Components Found In \(stateURL)")
            }
        } else {
            /// No File Path to Restore.
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let source = tableView.dataSource as? Self else {
            fatalError("Wrong type of data source!")
        }
        source.checkCache(tableView: tableView)
        restoreState()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Do not call super method here. Previously caused a crash for unknown reason.
        guard let source = tableView.dataSource as? Self else {
            assert(false, "Wrong data source!")
            return
        }
        let cellURL = source.contents![indexPath.row] /// if row is requested, that means there are non-zero rows, so contents is non-nil.
        if cellURL.isDirectory {
            let vc = FolderViewController(url: cellURL, selectionDelegate: selectionDelegate)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            /**
             In compact width mode, it seems as though the `.secondary` view controller in `UISplitViewController` is lazily loaded,
             so it's possible that ``selectionDelegate``'s `splitController` resolves to `nil` (which I observed).
             Therefore, as the active view we need to push the detail view onto the stack.
             */
            assert(splitViewController != nil, "Could not find ancestor split view!")
            splitViewController?.show(.secondary)
            
            selectionDelegate.select(cellURL, onClose: {
                /// Fade cell back to normal color, so that the cell doesn't stay gray.
                tableView.deselectRow(at: indexPath, animated: true)
            })
        }
    }
    
    func delete(at indexPath: IndexPath) -> Void {
        let cellURL: URL = contents![indexPath.row]
        do {
            selectionDelegate.delete(cellURL)
            try FileManager.default.removeItem(at: cellURL)
        } catch let error as NSError {
            assert(false, "Error \(error.domain)")
        }
        
        /// Wrap deletion in animation block
        /// Docs: https://developer.apple.com/documentation/uikit/uitableview/2887515-performbatchupdates
        tableView.performBatchUpdates {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        /// If folder is now empty, reflect that.
        if contents?.isEmpty == true {
            folder.show(.empty)
        }
    }
}
