//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 8/8/21.
//

import Foundation

extension Node {
    /// ``parent``'s previous child, if any
    var prevSibling: Node? {
        guard let idx = indexInParent else { return nil }
        return idx - 1 >= 0
            ? parent.children[idx - 1]
            : nil
    }

    /// ``parent``'s next child, if any
    var nextSibling: Node? {
        guard let idx = indexInParent else { return nil }
        return idx + 1 < parent.children.count
            ? parent.children[idx + 1]
            : nil
    }
}
