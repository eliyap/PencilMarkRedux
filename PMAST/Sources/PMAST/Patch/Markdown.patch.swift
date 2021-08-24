//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

fileprivate typealias ChunkChangeDetails = (offset: Int, element: Chunk, associatedWith: Int?)

extension Markdown {
    public mutating func patch(with new: String) {
        let oldChunks = plain.makeLines().chunked()
        
        let newLines = new.makeLines()
        let newChunks = newLines.chunked()
        
        let chunkDiff = newChunks.difference(from: oldChunks)
        
        chunkDiff.report() /// - Warning: DEBUG
        
        chunkDiff
            .forEach { (chunkChange: ChunkChange) in
                print("Change \(chunkChange.startIndex)")
                switch chunkChange {
                case .insert(let offset, let element, let associatedWith):
                    insert(details: (offset, element, associatedWith), new: new, newLines: newLines)
                case .remove(let offset, let element, let associatedWith):
                    remove(details: (offset, element, associatedWith), new: new, newLines: newLines)
                }
            }
    }
    
    fileprivate mutating func insert(
        details: ChunkChangeDetails,
        new: String,
        newLines: [Line]
    ) -> Void {
        let node = Parser.shared.parse(markdown: new.contents(of: details.element))
        
        /// Shift new nodes into the correct ``position``.
        let offset = Point(column: 0, line: details.element.startIndex, offset: details.element.lowerBound)
        node.offsetPosition(by: offset)
        
        /// Locate immediately preceding node.
        let precedingIndex = ast.children.lastIndex { $0.position.end.offset <= details.element.lowerBound }
        
        let insertionIndex = precedingIndex != nil
            ? precedingIndex! + 1     /// Insertion point should be after the identified node.
            : ast.children.startIndex /// assume start of tree if not found.
        
        /// Offset following nodes to account for inserted lines.
        ast.children[insertionIndex..<ast.children.endIndex].forEach {
            $0.offsetPosition(by: details.element.chunkSize)
        }
        
        /// Also offset the document end to account for inserted lines.
        ast.position.end += details.element.chunkSize
        
        /// Insert node into tree structure.
        ast.graft(node, at: insertionIndex)
        
        print(ast.description)
    }
    
    fileprivate mutating func remove(
        details: ChunkChangeDetails,
        new: String,
        newLines: [Line]
    ) -> Void {
        let targetIndex: Int? = ast.children.firstIndex { details.element.lowerBound <= $0.position.start.offset && $0.position.end.offset <= details.element.upperBound }
        guard let targetIndex = targetIndex else { /// Warning: conventional `let` unwrap leads to a sigtrap compile failure!
            assert(false, "Could not find target node!")
            return
        }
        
        /// Offset following nodes to account for removed lines.
        ast.children[targetIndex..<ast.children.endIndex].forEach { $0.offsetPosition(by: -details.element.chunkSize)}
        
        /// Also offset the document end to account for removed lines.
        ast.position.end -= details.element.chunkSize
        
        /// Manually set `root` column to be consistent with text.
        if let lastLine = newLines.last {
            /// Add one to account for 1-indexing.
            ast.position.end.column = lastLine.string.utf16.count + 1
        }
        
        /// Disconnect node, allowing it to be de-allocated.
        ast.children[targetIndex].parent = nil
        ast.children.remove(at: targetIndex)
    }
    
    
}
