//
//  Code.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation
import UIKit

public final class Code: Literal, LeafBlock {
    
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
        codeRange = getCodeRange(text: text)
    }
    
    required init(_ node: Node, parent: Parent!) {
        let code = (node as! Code)
        self.lang = code.lang
        self.meta = code.meta
        
        super.init(node, parent: parent)
    }
    
    fileprivate func getCodeRange(text: String) -> NSRange {
        let contents: String = String(text[position.nsRange])
        let nsContents = NSString(string: contents)
        var range: NSRange
        
        if value.isEmpty {
            
            /// Must be a fenced (not indented) block!
            precondition(contents[0..<3] == "~~~" || contents[0..<3] == "```")
            if contents.contains(where: \.isNewline) {
                let newlineRange: NSRange = nsContents.rangeOfCharacter(from: .newlines)
                precondition(newlineRange.lowerBound != NSNotFound)
                range = NSMakeRange(newlineRange.upperBound, 0)
            } else {
                /// Filter out corner case `~~~~~~` (3 open, 3 close)
                range = NSMakeRange(3, 0)
            }
        } else {
            range = nsContents.range(of: value)
            precondition(range.lowerBound != NSNotFound, """
                Could not find value in fence!
                V: '\(value)'
                C: '\(contents)'
                """)
        }
        
        /// Adjust range into document position.
        return NSMakeRange(position.nsRange.lowerBound + range.lowerBound, range.length)
    }
    
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        
        /// Color whole code block.
        string.addAttribute(.foregroundColor, value: UIColor.blue, range: position.nsRange)
    }
}
