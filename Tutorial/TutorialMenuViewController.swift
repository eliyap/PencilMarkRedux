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
        preferredContentSize.height = 0
            + tableView.rowHeight * CGFloat(Tool.Pencil.allCases.count)
            + tableView.rowHeight * CGFloat(Tool.Eraser.allCases.count)
            + tableView.sectionHeaderHeight * CGFloat(Tool.allCases.count)
        preferredContentSize.width = popoverWidth
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.sectionHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case Tool.pencil.rawValue:
            guard let gesture = Tool.Pencil(rawValue: indexPath.row) else {
                assert(false, "Unrecognized Pencil Gesture \(indexPath.row)")
                return
            }
            
            /// Pass in navHeight explicitly, as child seems not to be able to access it.
            navigationController?.pushViewController(VideoViewController(url: gesture.url, navHeight: navBarHeight), animated: true)
            
        case Tool.eraser.rawValue:
            guard let gesture = Tool.Eraser(rawValue: indexPath.row) else {
                assert(false, "Unrecognized Eraser Gesture \(indexPath.row)")
                return
            }
            
            /// Pass in navHeight explicitly, as child seems not to be able to access it.
            navigationController?.pushViewController(VideoViewController(url: gesture.url, navHeight: navBarHeight), animated: true)
            
        default:
            assert(false, "Unrecognized Section \(indexPath.section)")
            break
        }
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
    
    override var sectionHeaderHeight: CGFloat {
        get { 30 } /// an observed sufficient value for the largest non-accesbility text size
        set {  /* Ignore */ }
    }
}

// MARK: - Data Source
final class TutorialDataSource: NSObject, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Tool.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Tool(rawValue: section)!.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Tool.pencil.rawValue:
            return Tool.Pencil.allCases.count
        case Tool.eraser.rawValue:
            return Tool.Eraser.allCases.count
        default:
            fatalError("Unrecognized Section \(section)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch indexPath.section {
        case Tool.pencil.rawValue:
            if let gesture = Tool.Pencil(rawValue: indexPath.row) {
                cell.textLabel?.text = gesture.name
                cell.imageView?.image = UIImage(systemName: gesture.symbol)
            } else {
                assert(false, "Invalid Row: \(indexPath.row)")
            }
            
        case Tool.eraser.rawValue:
            if let gesture = Tool.Eraser(rawValue: indexPath.row) {
                cell.textLabel?.text = gesture.name
                cell.imageView?.image = UIImage(systemName: gesture.symbol)
            } else {
                assert(false, "Invalid Row: \(indexPath.row)")
            }
            
        default:
            fatalError("Unrecognized Section \(indexPath.section)")
        }
        
        return cell
    }
}
