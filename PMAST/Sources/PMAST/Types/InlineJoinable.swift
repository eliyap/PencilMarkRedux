//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 8/8/21.
//

import Foundation

/// Elements that are inline, that can easily be joined together.
/// e.g. `**a****b**` should be `**ab**`
protocol InlineJoinable: Node {
    /**
     Simple initializer allows us to create parents explicitly for insertion into the tree.
     */
    init(parent: Parent?, position: Position, _type: String)
}
