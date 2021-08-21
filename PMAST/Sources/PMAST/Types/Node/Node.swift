//
//  Node.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

public class Node {
    /// The ``Parent``, of which this is a member of ``children``.
    /// `weak` to avoid a strong reference cycle.
    /// Optional because `weak`.
    weak var parent: Parent!
    
    /// The position of the substring in the source Markdown that this Node represents.
    public internal(set) var position: Position
    
    /// An internal string for figuring out node type independent of class hierarchy
    var _type: String
    
    /// Internal, transient markers signalling that this node is part of a modification we want to make
    /// - Note: by convention, ``_content_change`` on non-``Literal`` classes has no effect on ``get_replacement``.
    ///   - however, it still signals that the ``Parent``'s contents will all be removed, especially in the tree infection algorithm.
    var _leading_change: Change? = nil /// leading syntax changes
    var _content_change: Change? = nil /// content changes, applies to literals mostly
    var _trailing_change: Change? = nil /// trailing syntax changes
    
    /// The string marking the node's class in JavaScript.
    class var type: String { "thematicBreak" }
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?) {
        if
            let position = Position(dict: dict?["position"] as? [AnyHashable: Any]),
            let _type = dict?["type"] as? String
        {
            self.position = position
            self._type = _type
            self.parent = parent
        } else {
            print("Failed to initalize literal of type \(dict?["type"] as? String ?? "No Type")!")
            print("Dict: \(String(describing: dict))")
            return nil
        }
    }
    
    init(parent: Parent?, position: Position, _type: String) {
        self.parent = parent
        self.position = position
        self._type = _type
    }
    
    /// Recursive function that gathers all ``Node``s which are marked as having changed.
    func gatherChanges() -> [Node] {
        /// include `self` if flagged for change,
        (_leading_change ?? _content_change ?? _trailing_change != nil)
            ? [self]
            : []
    }
    
    /// The text replacements that need to happen when this part of the tree is changed.
    func getReplacement() -> [Replacement] {
        print("Warning: Generic getReplacement called because inheriting class did not implement it!")
        return [] /// override to replace this
    }
}

extension Node {
    /// index in parent's ``children`` array.
    var indexInParent: Int? {
        parent?.children
            .firstIndex { $0 == self }! /// force unwrap!
    }
}
