//
//  Constants.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 22/7/21.
//

import Foundation
import UIKit

/// https://www.hackingwithswift.com/books/ios-swiftui/writing-data-to-the-documents-directory
let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

let tint = UIColor.orange

/// Source: https://developer.apple.com/documentation/uikit/uiviewcontroller/1619323-contentsizeforviewinpopover
let popoverWidth: CGFloat = 320

/// Colors in my `xcassets`.
extension UIColor {
    static let tableBackgroundColor = UIColor(named: "tableBackgroundColor")
    static let documentBackgroundColor = UIColor(named: "documentBackgroundColor")
}
