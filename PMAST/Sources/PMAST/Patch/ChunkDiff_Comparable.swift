//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 24/8/21.
//

import Foundation

typealias ChunkChange = CollectionDifference<Chunk>.Element

extension ChunkChange {
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

extension ChunkChange: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        /// Always let the later change go first.
        guard lhs.startIndex == rhs.startIndex else {
            return lhs.startIndex > rhs.startIndex
        }
        switch (lhs, rhs) {
        case (.insert, .remove):
            return true /// let removal go first
        case (.remove, .insert):
            return false /// let removal go first
        default:
            fatalError("Two Insertions / Removals at the same line index!")
        }
    }
}
