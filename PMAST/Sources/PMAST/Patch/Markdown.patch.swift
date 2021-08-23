//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

extension Markdown {
    public mutating func patch(with new: String) {
        let oldChunks = plain.makeLines().chunked()
        let newChunks = new.makeLines().chunked()
        
        let diff = newChunks.difference(from: oldChunks)
        diff.report()
        
        diff.forEach { change in
            switch change {
            case .insert(let offset, let element, let associatedWith):
                let node = Parser.shared.parse(markdown: new.contents(of: element))
                #warning("TODO: insert this into tree")
                /// adjust node positions
                
                /// adjust following positions
                /// insert node into tree structure
                    /// locate insertion point
                let insertionIndex = ast.children.firstIndex { $0.position.end.offset < element.lowerBound }
                    ?? 0 /// assume start of tree if not found.
                ast.graft(node, at: insertionIndex)
            case .remove(let offset, let element, let associatedWith):
                break
            }
        }
    }
}
