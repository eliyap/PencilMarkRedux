//
//  Link.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation
import UIKit

public final class Link: Parent {
    override class var type: String { "link" }

    let url: String
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?, text: String) {
        guard
            let url = dict?["url"] as? String
        else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
        self.url = url
        super.init(dict: dict, parent: parent, text: text)
    }
    
    /// Deep Copy Constructor.
    required init(_ node: Node, parent: Parent!) {
        url = (node as! Self).url
        super.init(node, parent: parent)
    }
    
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        
        /// Color in URL.
        let linkText = string.string[position.nsRange]
        var urlRange: NSRange = linkText.nsRanges(of: url).last!
        urlRange = urlRange.offset(by: position.nsRange.lowerBound)
        string.addAttribute(.foregroundColor, value: UIColor.blue, range: urlRange)
    }
}
