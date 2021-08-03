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
        print("backgrounded!")
    }
}
