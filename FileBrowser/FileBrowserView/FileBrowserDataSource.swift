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
        
        let section = Section(rawValue: indexPath.row)!
        cell.imageView?.image = UIImage(systemName: section.sfSymbolName)
        cell.textLabel?.text = section.label
        cell.backgroundColor = .tableBackgroundColor
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Section.allCases.count
    }
}
}
