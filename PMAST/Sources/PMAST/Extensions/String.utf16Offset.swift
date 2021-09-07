//
//  String.utf16Offset.swift
//  
//
//  Created by Secret Asian Man Dev on 7/9/21.
//

import Foundation

extension String {
    /// Get the UTF16 offset of the previous Swift `Character`.
    func utf16Offset(before idx: Int) -> Int {
        let strIdx = index(from: idx)
        let prevStrIdx: String.Index = index(before: strIdx)
        return prevStrIdx.utf16Offset(in: self)
    }
    
    /// Get the UTF16 offset of the next Swift `Character`.
    func utf16Offset(after idx: Int) -> Int {
        let strIdx = index(from: idx)
        let nextStrIdx: String.Index = index(after: strIdx)
        return nextStrIdx.utf16Offset(in: self)
    }
}
