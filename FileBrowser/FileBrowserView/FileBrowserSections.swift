//
//  FileBrowserSections.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/9/21.
//

import Foundation

extension FileBrowser {

/// Top Level File Browser Sections.
enum Section: Int, CaseIterable {
    case iCloud = 0
    case others = 1
    
    var sfSymbolName: String {
        switch self {
        case .iCloud:
            return "icloud"
        case .others:
            return "doc.badge.plus"
        }
    }
    
    /// Display String for users.
    var label: String {
        switch self {
        case .iCloud:
            return "iCloud"
        case .others:
            return "Open Others"
        }
    }
}
}
