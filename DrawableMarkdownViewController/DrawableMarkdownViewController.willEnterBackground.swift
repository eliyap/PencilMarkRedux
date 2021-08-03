//
//  DrawableMarkdownViewController.willEnterBackground.swift
//  DrawableMarkdownViewController.willEnterBackground
//
//  Created by Secret Asian Man Dev on 2/8/21.
//

import UIKit

extension DrawableMarkdownViewController {
    /// Respond to app being backgrounded.
    func observeBackgrounding() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterBackground),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    @objc
    func willEnterBackground(_ notification: Notification) {
        guard let activity = view.window?.windowScene?.userActivity else {
            print("TODO: Log missing scene here!")
            return
        }
        if activity.userInfo == nil {
            activity.userInfo = [:]
        }
        
        /// Cast to allowed NS types
        /// Docs: https://developer.apple.com/documentation/foundation/nsuseractivity/1411706-userinfo
        if let url = document?.fileURL {
            activity.userInfo![PMStateKey.fileURL.rawValue] = url as NSURL
            print("saved URL")
        } else {
            activity.userInfo![PMStateKey.fileURL.rawValue] = NSNull()
            print("saved Null")
        }
        
        print("backgrounded!")
    }
}
