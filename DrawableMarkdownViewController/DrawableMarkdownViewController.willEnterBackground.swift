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
        saveState()
    }
    
    internal func saveState() -> Void {
        guard let activity = view.window?.windowScene?.userActivity else {
            SceneRestoration.log("Cannot Save State Due to Missing Scene!")
            return
        }
        if activity.userInfo == nil {
            activity.userInfo = [:]
        }
        
        saveFileURL(in: activity)
        saveFileBookmark(in: activity)
        saveTool(in: activity)
        SceneRestoration.print("\(Self.self) saved state.")
    }
    
    fileprivate func saveFileURL(in activity: NSUserActivity) -> Void {
        /// Work around lack of `NSURL?`, which must be approximated using allowed NS types.
        /// Docs: https://developer.apple.com/documentation/foundation/nsuseractivity/1411706-userinfo
        let fileNsUrl: Any
        if let url = model.document?.fileURL {
            fileNsUrl = url as NSURL
        } else {
            fileNsUrl = NSNull()
        }
        activity.addUserInfoEntries(from: [ActivityInfo.fileURL.rawValue: fileNsUrl])
    }
    
    fileprivate func saveFileBookmark(in activity: NSUserActivity) -> Void {
        guard let url = model.document?.fileURL else { return }
        
        if let bookmarkData = try? url.bookmarkData() {
            let bookmarkInfo: [AnyHashable: Any] = [ActivityInfo.bookmarks.rawValue: bookmarkData as NSData]
            activity.addUserInfoEntries(from: bookmarkInfo)
        } else {
            SceneRestoration.log("Failed to create bookmark data!")
        }
    }
    
    fileprivate func saveTool(in activity: NSUserActivity) -> Void {
        let toolInfo: [AnyHashable: Any] = [ActivityInfo.activeTool.rawValue: model.tool.rawValue as NSInteger]
        activity.addUserInfoEntries(from: toolInfo)
    }
}
