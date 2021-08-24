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
    
    var lowerBound: Int {
        /// We may assume the chunk is non empty.
        first!.substringNsRange.lowerBound
    }
    
    var upperBound: Int {
        /// We may assume the chunk is non empty.
        last!.substringNsRange.upperBound
    }
    
    /// The ``NSRange`` enclosing all lines in the chunk.
    var nsRange: NSRange {
        #if DEBUG /// Safety check for contiguous lines
        ((startIndex+1)..<endIndex).forEach { idx in
            precondition(self[idx-1].enclosingNsRange.upperBound == self[idx].enclosingNsRange.lowerBound, "Non Contiguous Lines!")
        }
        #endif
        
        /// We may assume the chunk is non empty.
        return NSMakeRange(lowerBound, upperBound - lowerBound)
    }
}

extension Chunk {
    var lowerEnclosingBound: Int {
        /// We may assume the chunk is non empty.
        first!.enclosingNsRange.lowerBound
    }
    
    var upperEnclosingBound: Int {
        /// We may assume the chunk is non empty.
        last!.enclosingNsRange.lowerBound
    }
    
    var enclosingNsRange: NSRange {
        return NSMakeRange(lowerEnclosingBound, upperEnclosingBound - lowerEnclosingBound)
    }
}

extension String {
    func contents(of chunk: Chunk) -> String {
        NSString(string: self).substring(with: chunk.nsRange)
    }
}
