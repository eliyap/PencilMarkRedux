//
//  TutorialMenuViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 10/8/21.
//

import UIKit

final class TutorialMenuViewController: UINavigationController {
    
    let table = TutorialTableViewController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        adopt(table)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
}

final class TutorialTableViewController: UITableViewController {
    
    let source = TutorialDataSource()
    
    init() {
        super.init(style: .plain)
        
        tableView = TutorialTable()
        tableView.dataSource = source
        
        navigationItem.title = "Gestures"
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        preferredContentSize.height = tableView.rowHeight * CGFloat(Gesture.allCases.count)
        preferredContentSize.width = popoverWidth
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        precondition(indexPath.section == 0, "Unexpected Section \(indexPath.section)")
        
        guard let gesture = Gesture(rawValue: indexPath.row) else {
            assert(false, "Invalid Row \(indexPath.row)")
            return
        }
        
        /// Pass in navHeight explicitly, as child seems not to be able to access it.
        navigationController?.pushViewController(VideoViewController(url: gesture.url, navHeight: navBarHeight), animated: true)
    }
}

final class TutorialTable: UITableView {
    /// Initialize new cell if one is not available
    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        super.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell()
    }
    
    /// Guess-timate a sufficient height to display the text, with some padding.
    /// Set this explicitly so we know the table size ahead of time.
    override var rowHeight: CGFloat {
        get { UIFont.dynamicSize * 2.5 }
        set {  /* Ignore */ }
    }
}

// MARK: - Data Source
final class TutorialDataSource: NSObject, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Gesture.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let gesture = Gesture(rawValue: indexPath.row)
        cell.textLabel?.text = gesture?.name
        
        return cell
    }
}
