//
//  FileBrowserViewController.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 22/7/21.
//

import Foundation
import UIKit

extension FileBrowser{
final class ViewController: UITableViewController {
    
    typealias DocumentDelegate = DrawableMarkdownViewController
    
    /// Keep a strong reference to the data source, as the `UITableView` does not.
    let source: DataSource
    
    weak var selectionDelegate: DocumentDelegate!
    
    /// Lets us know if the user picked a document outside the sandbox.
    /// Maintain a strong reference because the ``UIDocumentPickerViewController`` cannot.
    var pickerDelegate: PickerDelegate? = nil
    
    /// Latch variable to ensure state restoration is triggered only once.
    var wasRestored = false
    
    init(selectionDelegate: DocumentDelegate) {
        self.source = DataSource()
        self.selectionDelegate = selectionDelegate
        super.init(style: .plain)
        
        /// Assign custom view.
        tableView = View()
        
        /// Assign custom Data Source.
        tableView.dataSource = source
    }
    
    fileprivate func restoreState() -> Void {
        /// Only restore once, and only after the model is ready.
        guard wasRestored == false, StateModel.shared.restored else { return }
        wasRestored = true
        
        guard let url = StateModel.shared.url else { return }
        guard let iCloudStr = FileBrowser.iCloudURL?.relativeString else {
            assert(false, "Could not resolve iCloud URL")
            return
        }
        if let end = url.relativeString.ranges(of: iCloudStr).first?.upperBound {
            print("iCloud Path: ", url.relativeString[end...])
        } else {
            print("Non iCloud Path: ", url.relativeString)
        }
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
        case Section.iCloud.rawValue:
            /// Push over to iCloud Drive.
            let iCloudVC = FolderViewController(url: iCloudURL, selectionDelegate: selectionDelegate)
            navigationController?.pushViewController(iCloudVC, animated: true)
        case Section.others.rawValue:
            presentPicker()
        default:
            fatalError("Index Out of Bounds \(indexPath.row)")
        }
        
        /// Fade cell back to normal color, so that "Open" doesn't stay gray.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Present modal document picker.
    fileprivate func presentPicker() -> Void {
        /**
         Construct a delegate that can inform us of picks.
         Hold a strong reference to it, pass it to the picker (which only has a weak reference).
         */
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.plainText])
        pickerDelegate = PickerDelegate { [weak self] (urls: [URL]) -> () in
            /**
             In compact width, `UISplitViewController`'s `.secondary` view controller seems to be lazily loaded,
             then, ``selectionDelegate``'s `splitController` resolves to `nil` (which I observed).
             Therefore, we explicitly push the detail view onto the stack.
             */
            assert(self?.splitViewController != nil, "Could not find ancestor split view!")
            self?.splitViewController?.show(.secondary)
            
            self?.selectionDelegate.select(urls[0], onClose: { })
        }
        picker.delegate = pickerDelegate
        present(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restoreState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// In testing, this was the earliest setting the color actually worked.
        /// `init` and `viewDidLoad`did not work.
        tableView.backgroundColor = .tableBackgroundColor
        
        restoreState()
    }
}
}
