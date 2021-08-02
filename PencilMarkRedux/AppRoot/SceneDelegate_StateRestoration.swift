//
//  SceneDelegate_StateRestoration.swift
//  SceneDelegate_StateRestoration
//
//  Created by Secret Asian Man Dev on 1/8/21.
//

import UIKit

extension SceneDelegate {
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        print("Has user activity: \(scene.userActivity != nil)")
        return scene.userActivity
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print("Continuing scene")
    }
    
    func scene(_ scene: UIScene, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        assert(false, "Failed to continue scene!")
    }
}
