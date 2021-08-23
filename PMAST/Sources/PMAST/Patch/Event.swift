//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

/// Borrowed from UNIST, an event occurs when we enter / exit a node.
/// Used to check whether 2 ASTs are functionally equivalent for our purposes.
public enum Event {
    /// Entering a node.
    case enter(point: Point, type: String)
    
    /// Describe a ``Node``'s contents.
    /// Intended for use by ``Literal``s so we can inspect their ``value``.
    case contents(String)
    
    /// Exiting a node.
    case exit(point: Point, type: String)
}

extension Event: Equatable {
    /// Automagical!
}
