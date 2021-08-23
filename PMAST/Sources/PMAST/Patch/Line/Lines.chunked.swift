//
//  Lines.chunked.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

extension Array where Element == Line {
    internal func chunked() -> [Chunk] {
        let boundaries = findBoundaries()
        return (1..<boundaries.count)
            .map { idx in
                self[boundaries[idx-1]..<boundaries[idx]]
            }
            .map(\.trimmed)
            .filter {
                /// Discard empty chunks
                $0.isEmpty == false
            }
    }
    
    fileprivate func findBoundaries() -> [Boundary] {
        var boundaries: [Array<Line>.Index] = []
        
        indices.forEach { idx in
            let line = self[idx]
            
            /// Skip blank lines,
            guard line.string.isBlank == false else { return }
            
            /// Check if preceding line (if any) is blank,
            /// and that the line could not be continuing a block (besides a fenced code block).
            if idx == 0 || (self[idx - 1].string.isBlank && (line.string.isPotentiallyContinuation == false)) {
                boundaries.append(idx + 1) /// adjust for 1 indexing
            }
        }
        
        /// Cap the document at both ends.
        return [0] + boundaries + [endIndex]
    }
}
