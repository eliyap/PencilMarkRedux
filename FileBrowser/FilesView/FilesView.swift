//
//  FilesView.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 20/7/21.
//

import UIKit

final class FilesView: UITableView {
    override func dequeueReusableCell(withIdentifier identifier: String) -> FilesViewCell? {
        super.dequeueReusableCell(withIdentifier: identifier) as? FilesViewCell
    }
    
    /// Scroll to the passed index path, which is assumed to be valid.
    /// If `select`, also select the row.
    func reveal(_ indexPath: IndexPath, select: Bool) {
        performBatchUpdates {
            insertRows(at: [indexPath], with: .automatic)
        } completion: { (finished) in
            /// Scroll row into view **after** insertion is complete!
            /// Docs: https://developer.apple.com/documentation/uikit/uitableview/1614875-selectrow
            if select  {
                self.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
            self.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
}
