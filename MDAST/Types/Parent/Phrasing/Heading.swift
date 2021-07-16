//
//  Heading.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import UIKit

final class Heading: Parent {
    
    override class var type: String { "heading" }
    
    let depth: Int
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?) {
        guard
            let depth = dict?["depth"] as? Int
        else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
        self.depth = depth
        super.init(dict: dict, parent: parent)
    }
    
    override func style(_ string: inout NSMutableAttributedString) {
        super.style(&string)
        string.addAttribute(
            .font,
            /// Match system's preferred heading font size
            value: UIFont.monospacedSystemFont(
                ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize,
                weight: .semibold
            ),
            range: position.nsRange
        )
    }
    
    override func getReplacement() -> [StyledMarkdown.Replacement] {
        switch _change {
        case .none:
            fatalError("Replacement requested for nil change!")
        case .toAdd:
            fatalError("Not Implemented!")
        case .toRemove:
            if let leading = leadingRange, let trailing = trailingRange {
                return [
                    StyledMarkdown.Replacement(range: leading, replacement: ""),
                    StyledMarkdown.Replacement(range: trailing, replacement: ""),
                ]
            } else {
                print("Requested replacement on Heading with no children!")
                
                /// return whole range to erase everything
                return [StyledMarkdown.Replacement(range: position.nsRange, replacement: "")]
            }
        }
    }
}

