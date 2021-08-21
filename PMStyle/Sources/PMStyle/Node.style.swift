//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 20/8/21.
//

import Foundation
import PMAST

// MARK: - Foundational Nodes
extension Node: Stylist {
    @objc /// extension overridable
    func style(_ string: NSMutableAttributedString) -> Void {
        /// Override to apply styles here.
    }
}

extension Parent {
     override func style(_ string: NSMutableAttributedString) -> Void {
        super.style(string)
        /// Recursively let each child apply their own styles.
        children.forEach { $0.style(string) }
    }
}
