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
                let (_, _) = (offset, associatedWith) /// Hush now, Swift.
                let node = Parser.shared.parse(markdown: new.contents(of: element))
                /// Adjust node positions.
                let offset = Point(column: 0, line: element.startIndex, offset: element.lowerBound)
                node.offsetPosition(by: offset)
                
                /// adjust following positions
                #warning("TODO: ^")
                
                /// Locate immediately preceding node.
                let precedingIndex = ast.children.lastIndex { $0.position.end.offset <= element.lowerBound }
                
                let insertionIndex = precedingIndex != nil
                    ? precedingIndex! + 1     /// Insertion point should be after the identified node.
                    : ast.children.startIndex /// assume start of tree if not found.
                
                /// Insert node into tree structure.
                ast.graft(node, at: insertionIndex)
            case .remove(let offset, let element, let associatedWith):
                break
            }
        }
    }
}
