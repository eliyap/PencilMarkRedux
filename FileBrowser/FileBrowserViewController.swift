//
//  FileBrowserViewController.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 22/7/21.
//

import Foundation
import UIKit

final class FileBrowserViewController: UITableViewController {
    
    typealias DocumentDelegate = DrawableMarkdownViewController
    
    /// Keep a strong reference to the data source, as the `UITableView` does not.
    let source: FileBrowserDataSource
    
    weak var selectionDelegate: DocumentDelegate!
    
    /// Lets us know if the user picked a document outside the sandbox.
    /// Maintain a strong reference because the ``UIDocumentPickerViewController`` cannot.
    let pickerDelegate: PickerDelegate!
    
    var iCloudURL: URL? {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)?
            .appendingPathComponent("Documents")
    }
    
    init(selectionDelegate: DocumentDelegate) {
        self.source = FileBrowserDataSource()
        self.selectionDelegate = selectionDelegate
        self.pickerDelegate = PickerDelegate() /// need to set implicitly unwrapped weak parent
        super.init(style: .plain)
        pickerDelegate.fileBrowser = self /// set implicitly unwrapped weak parent
        
        /// Assign custom view.
        tableView = FileBrowserView()
        
        /// Assign custom Data Source.
        tableView.dataSource = source
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
    
    /// Defer to data source.
    override func numberOfSections(in tableView: UITableView) -> Int {
        source.numberOfSections(in: tableView)
    }
    
    /// Defer to data source.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        source.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        precondition(indexPath.section == 0, "Unexpected Section \(indexPath.section)")
        
        switch indexPath.row {
        case 0:
            /// Push over to iCloud Drive.
            let iCloudVC = FolderViewController(url: iCloudURL, selectionDelegate: selectionDelegate)
            navigationController?.pushViewController(iCloudVC, animated: true)
        case 1:
            /// Present modal document picker.
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.plainText])
            picker.delegate = pickerDelegate
            present(picker, animated: true, completion: nil)
        default:
            fatalError("Index Out of Bounds \(indexPath.row)")
        }
        
        /// Fade cell back to normal color, so that "Open" doesn't stay gray.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

final class FileBrowserView: UITableView {
    /// Initialize new cell if one is not available
    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        super.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell()
    }
}

final class FileBrowserDataSource: NSObject, UITableViewDataSource {
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
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
}

final class PickerDelegate: NSObject, UIDocumentPickerDelegate {
    
    public weak var fileBrowser: FileBrowserViewController!
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("Picked!")
        precondition(urls.count == 1, "\(urls.count) documents picked!")
        
        /**
         In compact width mode, it seems as though the `.secondary` view controller in `UISplitViewController` is lazily loaded,
         so it's possible that ``selectionDelegate``'s `splitController` resolves to `nil` (which I observed).
         Therefore, as the active view we need to push the detail view onto the stack.
         */
        assert(fileBrowser.splitViewController != nil, "Could not find ancestor split view!")
        fileBrowser.splitViewController?.show(.secondary)
        
        fileBrowser.selectionDelegate.select(FileBrowserViewController.DocumentDelegate.Document(fileURL: urls[0]))
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Cancelled!")
    }
}
