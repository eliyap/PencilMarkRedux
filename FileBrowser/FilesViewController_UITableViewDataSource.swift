//
//  FilesViewController_UITableViewDataSource.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 20/7/21.
//

import Foundation
import UIKit

// MARK:- UITableViewDataSource Methods
extension FilesViewController {
    
    var contents: [URL]? {
        /// If folder cannot be located, return nil instead of empty
        guard let url = url else { return nil }
        
        guard let result = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: .none) else {
            print("Could not get contents for URL \(url)")
            return []
        }
        return result
            .filter { $0.lastPathComponent.first != "." } /// ignore `.Trash` and other system folders
            .sorted { $0.lastPathComponent < $1.lastPathComponent } /// ensure order is stable
    }
    
    /// Compares old data to current data. If they differ, we reload the whole view.
    func checkCache(tableView: UITableView) -> Void {
        if _cachedContents != contents {
            print("Contents Changed! Count \(String(describing: contents?.count))")
            _cachedContents = contents ?? [] /// if folder URL cannot be accessed, discard cached contents
            tableView.reloadData()
        }
        
        /// Expose or hide `FilesView` relative to `EmptyFolderView` depending on whether folder is empty or missing.
        switch contents?.count {
        case nil:
            folder.show(.inaccessible)
        case 0:
            folder.show(.empty)
        case .some:
            folder.show(.ok)
        }
        if (contents?.count ?? 0) == 0 {
            tableView.superview?.sendSubviewToBack(tableView)
        } else {
            tableView.superview?.bringSubviewToFront(tableView)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents?.count ?? 0 /// unreachable folder has 0 files.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        checkCache(tableView: tableView)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let cellURL = contents![indexPath.row] /// if row is requested, that means there are non-zero rows, so contents is non-nil.
        
        cell.textLabel?.text = cellURL.lastPathComponent
        
        /// Pick an appropriate icon for files / folders
        if cellURL.isDirectory {
            cell.imageView?.image = UIImage(systemName: "folder")
            cell.imageView?.tintColor = .gray
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.imageView?.image = UIImage(systemName: "doc.text")
            cell.imageView?.tintColor = tint
        }
        return cell
    }
}

