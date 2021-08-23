//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

/// A chunk is a contiguous slice of lines in a larger document.
typealias Chunk = ArraySlice<Line>

/// Marks the boundary between ``Chunk``s.
typealias Boundary = Array<Line>.Index
