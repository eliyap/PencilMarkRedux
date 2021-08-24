//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 24/8/21.
//

import Foundation

typealias ChunkDiff = CollectionDifference<Chunk>.Element

extension ChunkDiff {
    /// Expose `startIndex`.
    var startIndex: Chunk.Index {
        switch self {
        case .insert(_, let element, _):
            return element.startIndex
        case .remove(_, let element, _):
            return element.startIndex
        }
    }
}

extension ChunkDiff: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.startIndex < rhs.startIndex
    }
}
