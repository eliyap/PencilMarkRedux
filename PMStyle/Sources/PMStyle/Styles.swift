//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 20/8/21.
//

import PMAST
import UIKit

// MARK: - Styles
extension Code {
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        
        /// Color whole code block.
        string.addAttribute(.foregroundColor, value: UIColor.blue, range: position.nsRange)
    }
}

extension InlineCode {
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        
        /// Color whole code block.
        string.addAttribute(.foregroundColor, value: UIColor.blue, range: position.nsRange)
    }
}

extension ListItem {
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        if let leading = leadingRange, let trailing = trailingRange {
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: leading)
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: trailing)
        }
    }
}

extension Heading {
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
}

extension Delete {
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        string.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: position.nsRange)
        
        /// Style surrounding syntax marks
        if let leading = leadingRange, let trailing = trailingRange {
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: leading)
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: trailing)
        }
    }
}

extension Strong {
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        /// Runs the specified block for each differently formatted section of the provided range
        /// Docs: https://developer.apple.com/documentation/foundation/nsattributedstring/enumerationoptions
        string.enumerateAttribute(.font, in: position.nsRange, options: []) { font, range, _ in
            if let font = font as? UIFont {
                string.addAttribute(.font, value: font.adding(.traitBold), range: range)
            } else {
                /// `nil` indicates an unformatted string, so just apply bold to monospaced font
                string.addAttribute(.font, value: UIFont.monospacedSystemFont(ofSize: UIFont.dynamicSize, weight: .bold), range: range)
            }
        }
        
        /// Style surrounding syntax marks
        if let leading = leadingRange, let trailing = trailingRange {
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: leading)
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: trailing)
        }
    }
}

extension Emphasis {
    override func style(_ string: NSMutableAttributedString) {
        super.style(string)
        /// Runs the specified block for each differently formatted section of the provided range
        /// Docs: https://developer.apple.com/documentation/foundation/nsattributedstring/enumerationoptions
        string.enumerateAttribute(.font, in: position.nsRange, options: []) { font, range, _ in
            if let font = font as? UIFont {
                string.addAttribute(.font, value: font.adding(.traitItalic), range: range)
            } else {
                /// `nil` indicates an unformatted string, so just apply plain italics to monospaced font
                let font = UIFont.preferredFont(forTextStyle: .body)
                    .adding(.traitMonoSpace)
                    .adding(.traitItalic)
                string.addAttribute(.font, value: font, range: range)
            }
        }
        
        /// Style surrounding syntax marks
        if let leading = leadingRange, let trailing = trailingRange {
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: leading)
            string.addAttribute(.foregroundColor, value: UIColor.tertiaryLabel, range: trailing)
        }
    }
}
