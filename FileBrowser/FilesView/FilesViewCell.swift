//
//  FilesViewCell.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 20/9/21.
//

import UIKit

final class FilesViewCell: UITableViewCell {
    
    static let identifier: String = "FilesViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentConfiguration = ContentConfiguration()
        textLabel?.font = UIFont.monospacedSystemFont(ofSize: 100, weight: .black)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
