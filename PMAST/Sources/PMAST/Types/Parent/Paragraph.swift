//
//  Paragraph.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

public class Paragraph: Parent {
    override class var type: String { "paragraph" }
    
    override func equivalent(to other: Node) -> Bool {
        guard
            super.equivalent(to: other),
            let p = other as? Parent,
            children.count == p.children.count
        else {
            return false
        }
        
        /// Check all children for equivalency
        return (0..<children.count)
            .map { children[$0].equivalent(to: p.children[$0]) }
            .reduce(true, { $0 && $1 })
    }
}
