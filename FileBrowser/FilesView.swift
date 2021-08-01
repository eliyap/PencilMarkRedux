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
    
    /// Select and scroll to the passed index path, which is assumed to be valid.
    func reveal(_ indexPath: IndexPath) {
        performBatchUpdates {
            insertRows(at: [indexPath], with: .automatic)
        } completion: { (finished) in
            /// Scroll row into view **after** insertion is complete!
            /// Docs: https://developer.apple.com/documentation/uikit/uitableview/1614875-selectrow
            self.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
}
