//
//  FilesViewController.Refresh.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 20/7/21.
//

import Foundation
import UIKit

// MARK:- Refresh Control
extension FilesViewController {
    
    func configureRefresh() {
        /// Register refresh action
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc
    public func refresh() {
        checkCache(tableView: tableView)
        tableView.reloadData()
        
        /// Dismiss control
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            
            /// Assuming this is the child of a ``FolderViewController``, stop its refresh animation as well.
            (self.tableView.superview as? UIScrollView)?.refreshControl?.endRefreshing()
        }
    }
}
