//
//  SceneDelegate.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Determine the user activity from a new connection or from a session's state restoration.
        guard let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity else { return }
        
        _ = configure(window: window, session: session, with: userActivity)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        if let userActivity = window?.windowScene?.userActivity {
            userActivity.becomeCurrent()
            print("Scene resuming with activity")
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        if let userActivity = window?.windowScene?.userActivity {
            userActivity.resignCurrent()
            print("Scene resigning with activity")
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

// MARK: - Configuration
extension SceneDelegate {
    /// Cloned from Apple's sample StateRestoration app.
    func configure(window: UIWindow?, session: UISceneSession, with activity: NSUserActivity) -> Bool {
        var succeeded = true
        
        switch activity.activityType {
        case ActivityType.example.rawValue:
            break
        default:
            fatalError("Unrecognized activity type: \(activity.activityType)")
        }
        
        /// Restore file URL.
        StateModel.shared.url = activity.userInfo?[ActivityInfo.fileURL.rawValue] as? NSURL as URL?
        
        /// Restore active tool.
        if
            let rawTool = activity.userInfo?[ActivityInfo.activeTool.rawValue] as? NSInteger as Int?,
            let tool = Tool(rawValue: rawTool)
        {
            StateModel.shared.tool = tool
        }
        
        return succeeded
    }
}
