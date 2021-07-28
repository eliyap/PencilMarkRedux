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
    weak var selectionDelegate: FileBrowserViewController.DocumentDelegate!
    
    /// Allows us to bring error views to the front.
    weak var folder: FolderViewController!
    
    /// A cache of files previously seen in this folder.
    var _cachedContents: [URL] = []
    
    init(url: URL?, selectionDelegate: FileBrowserViewController.DocumentDelegate) {
        self.url = url
        self.selectionDelegate = selectionDelegate
        super.init(style: .plain)
       
        /// Attach custom `UITableView`
        let tableView = FilesView()
        self.tableView = tableView
        
        /// Attach refresh controller
        configureRefresh()
        
        /// Adjust for keyboard
        setupNotifications()
        
        /// Attach custom data source.
        self.tableView.dataSource = self
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
            
            selectionDelegate.select(cellURL)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cellURL: URL = contents![indexPath.row]
            do {
                try FileManager.default.removeItem(at: cellURL)
            } catch let error as NSError {
                assert(false, "Error \(error.domain)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            print("Insert Not Implemented")
        }
    }
}
