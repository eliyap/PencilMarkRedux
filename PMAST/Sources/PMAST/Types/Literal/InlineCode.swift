//
//  InlineCode.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation
import UIKit

public final class InlineCode: Literal, InlineJoinable {

    override class var type: String { "inlineCode" }
    
    required init?(dict: [AnyHashable : Any]?, parent: Parent?, text: String) {
        super.init(dict: dict, parent: parent, text: text)
    }
    
    required init(_ node: Node, parent: Parent!) {
        super.init(node, parent: parent)
    }
    
    /// Conformance to ``InlineJoinable``, allow no-value `init`.
    init(parent: Parent?, position: Position, _type: String) {
        super.init(parent: parent, position: position, _type: _type, value: "")
    }

    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        
        /// Color whole code block.
        string.addAttribute(.foregroundColor, value: UIColor.blue, range: position.nsRange)
    }
}
