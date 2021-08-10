//
//  TutorialMenuViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 10/8/21.
//

import UIKit

enum Gesture: Int, CaseIterable {
    case strike = 1
    case scribble
    
    var name: String {
        switch self {
        case .strike:
            return "Strike"
        case .scribble:
            return "Scribble"
        }
    }
}

final class TutorialMenuViewController: UITableViewController {
    
    init() {
        super.init(style: .plain)
        
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
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
