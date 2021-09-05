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
        
        let newLines = new.makeLines()
        var newBoundaries = newLines.findBoundaries()
        
        /// A disposable AST.
        var temp: Root
        var success = false
        
        /// Running at least once ensures (for compiler) that tree is initialized.
        repeat {
            /// Construct, then patch, new tree.
            temp = Root(ast, parent: nil)
            
            success = temp.patch(
                oldChunks: plain.makeLines().chunked(along: self.boundaries),
                newText: new,
                newLines: newLines,
                boundaries: &newBoundaries
            )
        } while success == false
        
        /// Finalize tree adjustments.
        ast = temp
        boundaries = newBoundaries
    }
}

extension Root {
    /**
     Modifies this MDAST to fit the new text.
     Elements in`boundaries` are removed if we find that they divide a fenced code block from the rest of its contents.
     Returns: `true` if there were no problems with the patch.
     */
    func patch(
        oldChunks: [Chunk],
        newText: String,
        newLines: [Line],
        boundaries: inout [Boundary]
    ) -> Bool {
        let newChunks = newLines.chunked(along: boundaries)
        
        let chunkDiff = newChunks.difference(from: oldChunks)
        
        for chunkChange in chunkDiff {
            switch chunkChange {
            case .insert(let offset, let element, let associatedWith):
                var hasUnclosedFence = false
                insert(details: (offset, element, associatedWith), newText: newText, newLines: newLines, hasUnclosedFence: &hasUnclosedFence)
                if
                    hasUnclosedFence,
                    /// If we reach the end of the document, that necessarily ends the code block, so we don't remove that boundary.
                    element.endIndex != boundaries.last
                {
                    /// Remove the offending boundary, and immediately exit to try again.
                    precondition(boundaries.contains(where: { $0 == element.endIndex }), "Could not locate boundary!")
                    boundaries = boundaries.filter { $0 != element.endIndex }
                    return false
                }
            case .remove(let offset, let element, let associatedWith):
                remove(details: (offset, element, associatedWith), newLines: newLines)
            }
        }
        
        /// Manually set the end position of the document.
        if newLines.isEmpty {
            position.end.line = 1
            position.end.column = 1
            position.end.offset = 0
        } else {
            position.end.line = newLines.count /// accounts for 1-indexing
            position.end.column = newLines.last!.string.utf16.count + 1 /// account for 1-indexing
            position.end.offset = newText.utf16.count
        }
        
        return true
    }
    
    /// Returns a flag indicating whether an unclosed fence was found!
    fileprivate func insert(
        details: ChunkChangeDetails,
        newText: String,
        newLines: [Line],
        hasUnclosedFence: inout Bool
    ) -> Void {
        let chunkText: String = newText.contents(of: details.element)
        let node = constructTree(from: Parser.shared.parse(chunkText), text: chunkText)
        
        let codeChildren: [Code] = node.children.compactMap { $0 as? Code }
        for child in codeChildren {
            let trailingFence = chunkText[child.position.nsRange].suffix(3)
            if trailingFence != "~~~" && trailingFence != "```" {
                hasUnclosedFence = true
            }
        }
        
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
        
        /// Insert node into tree structure.
        graft(node, at: insertionIndex)
    }
    
    fileprivate func remove(
        details: ChunkChangeDetails,
        newLines: [Line]
    ) -> Void {
        guard details.element.nsRange.length > 0 else {
            /// If the element is zero length (which can happen, due to the trailing empty line we insert ourselves), exit.
            return
        }
        
        /// Find all nodes in this chunk.
        let targetStart: Int? = children.firstIndex { details.element.lowerBound <= $0.position.start.offset && $0.position.end.offset <= details.element.upperBound }
        let targetEnd: Int? = children.lastIndex { details.element.lowerBound <= $0.position.start.offset && $0.position.end.offset <= details.element.upperBound }
        guard
            let targetStart = targetStart,
            let targetEnd = targetEnd
        else { /// Warning: conventional `let` unwrap leads to a sigtrap compile failure!
            assert(false, "Could not find target node! \(details.element.lowerBound)–\(details.element.upperBound)")
            return
        }
        
        /// Offset following nodes to account for removed lines.
        children[(targetEnd + 1)..<children.endIndex].forEach { $0.offsetPosition(by: -details.element.chunkSize) }
        
        /// Disconnect node, allowing it to be de-allocated.
        (targetStart...targetEnd).forEach { idx in
            children[idx].parent = nil
        }
        children.removeSubrange(targetStart...targetEnd)
    }
}
