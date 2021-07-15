//
//  TreeLinkCheck.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation

enum TreeError: Error {
    case link
}

extension Node {
    /// Check if all parents are correctly linked to their children
    func linkCheck() throws -> Void {
        try children.forEach {
            if $0.parent != self {
                throw TreeError.link
            }
        }
        try nodeChildren.forEach {
            try $0.linkCheck()
        }
    }
}
