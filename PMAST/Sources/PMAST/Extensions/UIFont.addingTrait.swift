//
//  UIFont_Style.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import UIKit

extension UIFont {
    func adding(_ trait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        /// add trait to font descriptor
        var traits = fontDescriptor.symbolicTraits
        traits.insert(trait)
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(traits)!, size: UIFont.dynamicSize)
    }
}
