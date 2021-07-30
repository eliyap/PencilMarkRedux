//
//  UIFont.dynamicSize.swift
//  UIFont.dynamicSize
//
//  Created by Secret Asian Man Dev on 30/7/21.
//

import UIKit

extension UIFont {
    /// User's preferred font size for the system body font.
    static var dynamicSize: CGFloat {
        UIFont.preferredFont(forTextStyle: .body).pointSize
    }
}
