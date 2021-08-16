//
//  ActivityInfo.swift
//  ActivityInfo
//
//  Created by Secret Asian Man Dev on 3/8/21.
//

import Foundation

/**
 * Keys used for state restoration in our `NSUserActivity` `userInfo`.
 */
enum ActivityInfo: NSString {
    case fileURL /// the URL of the open document
    case activeTool /// the user's active tool
}
