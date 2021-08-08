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

extension Node {
    /// Find the ``parent``'s closest previous child that is not marked for removal.
    var prevNonRemovedSibling: Node? {
        var result: Node? = prevSibling
        while let r = result {
            if r._change != .toRemove {
                return r
            } else {
                result = r.prevSibling
            }
        }
        return result
    }
    
    /// Find the ``parent``'s closest subsequent child that is not marked for removal.
    var nextNonRemovedSibling: Node? {
        var result: Node? = nextSibling
        while let r = result {
            if r._change != .toRemove {
                return r
            } else {
                result = r.nextSibling
            }
        }
        return result
    }
}