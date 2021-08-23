//
//  Markdown.chunked.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

internal extension Markdown {
    func getChunks(in lines: [Line]) -> [Chunk] {
        let boundaries = findBoundaries(in: lines)
        return (1..<boundaries.count)
            .map { idx in
                lines[boundaries[idx-1]..<boundaries[idx]]
            }
            .map(\.trimmed)
            .filter {
                /// Discard empty chunks
                $0.isEmpty == false
            }
    }
    
    func findBoundaries(in lines: [Line]) -> [Boundary] {
        var boundaries: [Array<Line>.Index] = []
        
        (lines.startIndex..<lines.endIndex).forEach { idx in
            let line = lines[idx]
            
            /// Skip blank lines,
            guard line.string.isBlank == false else { return }
            
            /// Check if preceding line (if any) is blank,
            /// and that the line could not be continuing a block (besides a fenced code block).
            if idx == 0 || (lines[idx - 1].string.isBlank && (line.string.isPotentiallyContinuation == false)) {
                boundaries.append(idx + 1) /// adjust for 1 indexing
            }
        }
        
        print("Found \(boundaries)")
        print("Actual \(ast.children.map(\.position.start.line))")
        
        /// Cap the document at both ends.
        return [0] + boundaries + [lines.endIndex]
    }
}
