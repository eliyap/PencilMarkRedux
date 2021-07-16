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
}

