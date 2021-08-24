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
        
        let chunkDiff = newChunks.difference(from: oldChunks)
        
        chunkDiff.report() /// - Warning: DEBUG
        
        chunkDiff
            .forEach { (chunkChange: ChunkChange) in
                print("Change \(chunkChange.startIndex)")
                switch chunkChange {
                case .insert(let offset, let element, let associatedWith):
                    insert(offset: offset, element: element, associatedWith: associatedWith, new: new)
                case .remove(let offset, let element, let associatedWith):
                    remove(offset: offset, element: element, associatedWith: associatedWith, new: new)
                }
            }
    }
    
    fileprivate mutating func insert(offset: Int, element: Chunk, associatedWith: Int?, new: String) -> Void {
        let node = Parser.shared.parse(markdown: new.contents(of: element))
        
        /// Shift new nodes into the correct ``position``.
        let offset = Point(column: 0, line: element.startIndex, offset: element.lowerBound)
        node.offsetPosition(by: offset)
        
        /// Locate immediately preceding node.
        let precedingIndex = ast.children.lastIndex { $0.position.end.offset <= element.lowerBound }
        
        let insertionIndex = precedingIndex != nil
            ? precedingIndex! + 1     /// Insertion point should be after the identified node.
            : ast.children.startIndex /// assume start of tree if not found.
        
        /// Offset following nodes to account for inserted lines.
        ast.children[insertionIndex..<ast.children.endIndex].forEach {
            $0.offsetPosition(by: element.chunkSize)
        }
        
        /// Also offset the document end to account for inserted lines.
        ast.position.end += element.chunkSize
        
        /// Insert node into tree structure.
        ast.graft(node, at: insertionIndex)
        
        print(ast.description)
    }
    
    fileprivate mutating func remove(offset: Int, element: Chunk, associatedWith: Int?, new: String) -> Void {
        let targetIndex: Int? = ast.children.firstIndex { element.lowerBound <= $0.position.start.offset && $0.position.end.offset <= element.upperBound }
        guard let targetIndex = targetIndex else { /// Warning: conventional `let` unwrap leads to a sigtrap compile failure!
            assert(false, "Could not find target node!")
            return
        }
        
        /// Offset following nodes to account for removed lines.
        ast.children[targetIndex..<ast.children.endIndex].forEach { $0.offsetPosition(by: -element.chunkSize)}
        
        /// Also offset the document end to account for removed lines.
        ast.position.end -= element.chunkSize
        
        /// Disconnect node, allowing it to be de-allocated.
        ast.children[targetIndex].parent = nil
        ast.children.remove(at: targetIndex)
    }
}
