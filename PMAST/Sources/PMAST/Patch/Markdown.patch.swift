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
                
                /// Locate immediately preceding node.
                let precedingIndex = ast.children.lastIndex { $0.position.end.offset <= element.lowerBound }
                
                let insertionIndex = precedingIndex != nil
                    ? precedingIndex! + 1     /// Insertion point should be after the identified node.
                    : ast.children.startIndex /// assume start of tree if not found.
                
                /// Offset following nodes to account for inserted lines.
                let chunkSize = Point(column: 0, line: element.count, offset: element.enclosingNsRange.length)
                ast.children[insertionIndex..<ast.children.endIndex].forEach {
                    $0.offsetPosition(by: chunkSize)
                }
                
                /// Also offset the document end to account for inserted lines.
                ast.position.end += chunkSize
                
                /// Insert node into tree structure.
                ast.graft(node, at: insertionIndex)
                
                print(ast.description)
            case .remove(let offset, let element, let associatedWith):
                break
            }
        }
    }
}
