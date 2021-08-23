//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

/// A contiguous slice of lines in a larger document.
typealias Chunk = ArraySlice<Line>

/// Marks the boundary between ``Chunk``s.
typealias Boundary = Array<Line>.Index

extension Chunk {
    /// The ``NSRange`` enclosing all lines in the chunk.
    var nsRange: NSRange {
        #if DEBUG /// Safety check for contiguous lines
        ((startIndex+1)..<endIndex).forEach { idx in
            precondition(self[idx-1].enclosingNsRange.upperBound == self[idx].enclosingNsRange.lowerBound, "Non Contiguous Lines!")
        }
        #endif
        
        /// We may assume the chunk is non empty.
        let low = first!.substringNsRange.lowerBound
        let upp = last!.substringNsRange.upperBound
        return NSMakeRange(low, upp - low)
    }
}

extension String {
    func contents(of chunk: Chunk) -> String {
        NSString(string: self).substring(with: chunk.nsRange)
    }
}
