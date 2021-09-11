//
//  LeafBlock.swift
//  
//
//  Created by Secret Asian Man Dev on 11/9/21.
//

import Foundation

/// As defined in https://github.github.com/gfm/#leaf-blocks
///
/// https://github.github.com/gfm/#container-blocks-and-leaf-blocks
/// > We can divide blocks into two types: container blocks,
/// > which can contain other blocks, and leaf blocks, which cannot.
protocol LeafBlock: Node {
    /// None
}
