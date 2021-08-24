//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 24/8/21.
//

import Foundation

extension Chunk {
    /// The size of the chunk, so that other lines can adjust their offsets to accomodate its insertion / removal.
    var chunkSize: Point {
        Point(
            column: 0,
            line: count,
            offset: enclosingNsRange.length
        )
    }
}
