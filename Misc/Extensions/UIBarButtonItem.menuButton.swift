//
//  UIBarButtonItem.menuButton.swift
//  UIBarButtonItem.menuButton
//
//  Created by Secret Asian Man Dev on 1/8/21.
//

import UIKit

extension UIBarButtonItem {

    /// Make a custom square image button.
    /// Source: https://stackoverflow.com/a/53454225/12395667
    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageView?.tintColor = tint
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true

        return menuBarItem
    }
}
