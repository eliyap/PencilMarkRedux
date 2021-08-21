//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 20/8/21.
//

import PMAST
import Foundation

extension Markdown {
    /// Exposed `style` method.
    public func style(_ string: NSMutableAttributedString) {
        ast.style(string)
    }
}
