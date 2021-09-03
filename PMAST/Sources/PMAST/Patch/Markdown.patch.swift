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
        let oldLines = plain.makeLines()
        let oldChunks = oldLines.chunked(along: oldLines.findBoundaries())
        
        let newLines = new.makeLines()
        let boundaries = newLines.findBoundaries()
        
        var didEncounterUnclosedFence = false
        
        #warning("TODO: implement conditional loop here!")
        
        /// Construct and patch temporary tree.
        let temp = constructTree(from: dict, text: plain)
        temp.patch(
            oldChunks: oldChunks,
            newText: new,
            newLines: newLines,
            boundaries: boundaries,
            flag: &didEncounterUnclosedFence
        )
        
        /// Finalize tree adjustments.
        ast = temp
    }
}

extension Root {
    func patch(
        oldChunks: [Chunk],
        newText: String,
        newLines: [Line],
        boundaries: [Boundary],
        flag: inout Bool
    ) -> Void {
        let newChunks = newLines.chunked(along: boundaries)
        
        let chunkDiff = newChunks.difference(from: oldChunks)
        
        chunkDiff.report() /// - Warning: DEBUG
        
        chunkDiff
            .forEach { (chunkChange: ChunkChange) in
                print("Change \(chunkChange.startIndex)")
                switch chunkChange {
                case .insert(let offset, let element, let associatedWith):
                    insert(details: (offset, element, associatedWith), newText: newText, newLines: newLines)
                case .remove(let offset, let element, let associatedWith):
                    remove(details: (offset, element, associatedWith), newLines: newLines)
                }
            }
    }
    
    fileprivate func insert(
        details: ChunkChangeDetails,
        newText: String,
        newLines: [Line]
    ) -> Void {
        let chunkText: String = newText.contents(of: details.element)
        let node = constructTree(from: Parser.shared.parse(chunkText), text: chunkText)
        
        /// Shift new nodes into the correct ``position``.
        let offset = Point(column: 0, line: details.element.startIndex, offset: details.element.lowerBound)
        node.offsetPosition(by: offset)
        
        /// Locate immediately preceding node.
        let precedingIndex = children.lastIndex { $0.position.end.offset <= details.element.lowerBound }
        
        let insertionIndex = precedingIndex != nil
            ? precedingIndex! + 1     /// Insertion point should be after the identified node.
            : children.startIndex /// assume start of tree if not found.
        
        /// Offset following nodes to account for inserted lines.
        children[insertionIndex..<children.endIndex].forEach {
            $0.offsetPosition(by: details.element.chunkSize)
        }
        
        /// Also offset the document end to account for inserted lines.
        position.end += details.element.chunkSize
        
        /// Insert node into tree structure.
        graft(node, at: insertionIndex)
        
        print(description)
    }
    
    fileprivate func remove(
        details: ChunkChangeDetails,
        newLines: [Line]
    ) -> Void {
        let targetIndex: Int? = children.firstIndex { details.element.lowerBound <= $0.position.start.offset && $0.position.end.offset <= details.element.upperBound }
        guard let targetIndex = targetIndex else { /// Warning: conventional `let` unwrap leads to a sigtrap compile failure!
            assert(false, "Could not find target node!")
            return
        }
        
        /// Offset following nodes to account for removed lines.
        children[targetIndex..<children.endIndex].forEach { $0.offsetPosition(by: -details.element.chunkSize)}
        
        /// Also offset the document end to account for removed lines.
        position.end -= details.element.chunkSize
        
        /// Manually set `root` column to be consistent with text.
        if let lastLine = newLines.last {
            /// Add one to account for 1-indexing.
            position.end.column = lastLine.string.utf16.count + 1
        }
        
        /// Disconnect node, allowing it to be de-allocated.
        children[targetIndex].parent = nil
        children.remove(at: targetIndex)
    }
}
