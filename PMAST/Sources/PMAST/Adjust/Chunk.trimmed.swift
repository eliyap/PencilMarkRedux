//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

extension Chunk {
    /// The chunk with leading and trailing blank lines trimmed off.
    var trimmed: Chunk {
        var result = self
        
        /// Trim leading blank lines
        while result.first?.string.isBlank == true {
            result = result[(result.startIndex + 1)..<result.endIndex]
        }
        
        /// Trim trailing blank lines
        while result.last?.string.isBlank == true {
            result = result[result.startIndex..<(result.endIndex - 1)]
        }
        
        return result
    }
}
