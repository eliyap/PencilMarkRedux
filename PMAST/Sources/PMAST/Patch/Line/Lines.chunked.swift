//
//  Lines.chunked.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

extension Array where Element == Line {
    internal func chunked(along boundaries: [Boundary]) -> [Chunk] {
        return (1..<boundaries.count)
            .map { idx in
                self[boundaries[idx-1]..<boundaries[idx]]
            }
            .filter {
                /// Discard empty chunks
                $0.isEmpty == false
            }
    }
    
    internal func findBoundaries() -> [Boundary] {
        var boundaries: [Array<Line>.Index] = []
        
        indices.forEach { idx in
            let line = self[idx]
            
            /// If line is blank, report it as a new chunk.
            /// This makes diffing easier.
            guard line.string.isBlank == false else {
                boundaries.append(idx + 1)
                return
            }
            
            /// Check if preceding line (if any) is blank,
            /// and that the line could not be continuing a block (besides a fenced code block).
            if
                (idx == 0 || self[idx - 1].string.isBlank),
                line.string.isPotentiallyContinuation == false
            {
                boundaries.append(idx)
            }
        }
        
        /// Cap the document at both ends.
        return [0] + boundaries + [endIndex]
    }
}
