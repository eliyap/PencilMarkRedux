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
    
    var codeRange: NSRange! = nil
    
    required init?(dict: [AnyHashable : Any]?, parent: Parent?, text: String) {
        let lang = dict?["lang"] as? String
        let meta = dict?["meta"] as? String
    
        self.lang = lang
        self.meta = meta
        super.init(dict: dict, parent: parent, text: text)
        
        let contents: String = String(text[position.nsRange])
        let nsContents = NSString(string: contents)
        
        if value.isEmpty {
            /// Must be a fenced (not indented) block!
            precondition(contents[0..<3] == "~~~" || contents[0..<3] == "```")
            if contents.contains(where: \.isNewline) {
                let newlineRange: NSRange = nsContents.rangeOfCharacter(from: .newlines)
                precondition(newlineRange.lowerBound != NSNotFound)
                codeRange = NSMakeRange(newlineRange.upperBound, 0)
            } else {
                /// Filter out corner case `~~~~~~` (3 open, 3 close)
                codeRange = NSMakeRange(3, 0)
            }
        } else {
            codeRange = nsContents.range(of: value)
            precondition(codeRange.lowerBound != NSNotFound, """
                Could not find value in fence!
                V: '\(value)'
                C: '\(contents)'
                """)
        }
    }
    
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        
        /// Color whole code block.
        string.addAttribute(.foregroundColor, value: UIColor.blue, range: position.nsRange)
    }
}
