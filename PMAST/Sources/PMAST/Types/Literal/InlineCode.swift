//
//  InlineCode.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation
import UIKit

public final class InlineCode: Literal {
    override class var type: String { "inlineCode" }
    
    override func style(_ string: inout NSMutableAttributedString) {
        super.style(&string)
        
        /// Color whole code block.
        string.addAttribute(.foregroundColor, value: UIColor.blue, range: position.nsRange)
    }
}
