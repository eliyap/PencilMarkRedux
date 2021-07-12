//
//  Delete.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import UIKit

final class Delete: Node {
    override class var type: String { "delete" }
    
    override func style(_ string: inout NSMutableAttributedString) {
        super.style(&string)
        string.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: position.nsRange)
    }
}
