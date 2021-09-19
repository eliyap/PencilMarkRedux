//
//  FileBrowserView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/9/21.
//

import UIKit

final class FileBrowserView: UITableView {
    /// Initialize new cell if one is not available
    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        super.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell()
    }
}
