//
//  Code.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation
import UIKit

public final class Code: Literal {
    
    override class var type: String { "code" }
    
    /// Presumably the coding language of the block
    var lang: String?
    
    /// Not sure what this is.
    var meta: String?
    
    required init?(dict: [AnyHashable : Any]?, parent: Parent?) {
        let lang = dict?["lang"] as? String
        let meta = dict?["meta"] as? String
    
        self.lang = lang
        self.meta = meta
        super.init(dict: dict, parent: parent)
    }
    
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        
        /// Color whole code block.
        string.addAttribute(.foregroundColor, value: UIColor.blue, range: position.nsRange)
    }
}
