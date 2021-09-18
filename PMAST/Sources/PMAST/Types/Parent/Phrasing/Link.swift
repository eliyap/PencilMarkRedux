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

extension StringProtocol {
    /// Find all ranges of a particular substring.
    func ranges(of substr: String) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var idx = startIndex
        while idx < index(endIndex, offsetBy: -substr.count) {
            if let range = self[idx..<index(idx, offsetBy: substr.count)].range(of: substr) {
                result.append(range)
            }
            idx = index(after: idx)
        }
        return result
    }
    
    /// Find all `NSRange`s of a particular substring.
    func nsRanges(of substr: String) -> [NSRange] {
        var result: [NSRange] = []
        var idx = startIndex
        while idx < index(endIndex, offsetBy: -substr.count) {
            if let range = self[idx..<index(idx, offsetBy: substr.count)].range(of: substr) {
                let low = range.lowerBound.utf16Offset(in: self)
                let upp = range.upperBound.utf16Offset(in: self)
                result.append(NSMakeRange(low, upp - low))
            }
            idx = index(after: idx)
        }
        return result
    }
}

fileprivate extension NSRange {
    func offset(by offset: Int) -> NSRange {
        NSMakeRange(offset + lowerBound, length)
    }
}
