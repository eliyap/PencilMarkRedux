//
//  FilesView.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 20/7/21.
//

import Foundation
import UIKit

final class FilesView: UITableView {
    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        super.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell()
    }
}
