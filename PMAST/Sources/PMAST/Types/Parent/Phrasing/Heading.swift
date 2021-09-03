//
//  Heading.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import UIKit

public final class Heading: Parent {
    
    override class var type: String { "heading" }
    
    let depth: Int
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?, text: String) {
        guard
            let depth = dict?["depth"] as? Int
        else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
        self.depth = depth
        super.init(dict: dict, parent: parent, text: text)
    }
    
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        /// Match system's preferred heading font size.
        string.addAttribute(
            .font,
            value: UIFont.monospacedSystemFont(
                ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize,
                weight: .semibold
            ),
            range: position.nsRange
        )
        
        /// De-emphasize syntax marks with a secondary color.
        /// Apply to leading (for ATX headings) and trailing (for Setext headings)
        if let leading = leadingRange, let trailing = trailingRange {
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: leading)
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: trailing)
        }
    }
    
    override func getReplacement() -> [Replacement] {
        var result: [Replacement] = []
        
        switch _leading_change {
        case .none:
            break
        case .toAdd:
            fatalError("Not Implemented!")
        case .toRemove:
            if let leading = leadingRange, let _ = trailingRange {
                result += [Replacement(range: leading, replacement: "")]
            } else {
                print("Requested replacement on Heading with no children!")
                
                /// return whole range to erase everything
                return [Replacement(range: position.nsRange, replacement: "")]
            }
        }
        
        switch _trailing_change {
        case .none:
            break
        case .toAdd:
            fatalError("Not Implemented!")
        case .toRemove:
            if let _ = leadingRange, let trailing = trailingRange {
                result += [Replacement(range: trailing, replacement: "")]
            } else {
                print("Requested replacement on Heading with no children!")
                
                /// return whole range to erase everything
                return [Replacement(range: position.nsRange, replacement: "")]
            }
        }
        
        return result
    }
}

