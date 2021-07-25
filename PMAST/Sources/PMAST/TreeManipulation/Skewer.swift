//
//  Skewer.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

extension Node {
    /// Find the top level skewered node
    func highestSkeweredAncestor(in range: NSRange) -> Node {
        var content: Node = self
        while (content.parent.skewered(by: range)) {
            content = content.parent
        }
        return content
    }
    
    /// whether the provided range totally encloses this node
    func skewered(by range: NSRange) -> Bool {
        range.lowerBound <= position.nsRange.lowerBound && position.nsRange.upperBound <= range.upperBound
    }
}
