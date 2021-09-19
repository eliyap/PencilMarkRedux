//
//  FileBrowserDataSource.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/9/21.
//

import UIKit

extension FileBrowser{
final class DataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        precondition(indexPath.section == 0, "Unexpected Section \(indexPath.section)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(systemName: "icloud")
            cell.textLabel?.text = "iCloud"
        case 1:
            cell.imageView?.image = UIImage(systemName: "doc.badge.plus")
            cell.textLabel?.text = "Open Others"
        default:
            fatalError("Index Out of Bounds \(indexPath.row)")
        }
        
        cell.backgroundColor = .tableBackgroundColor
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
}
}
