//
//  SplitConduit.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 13/8/21.
//

import Combine

/**
 Singleton class that passes through notifications when `UISplitViewController` has layout changes.
 */
final class SplitConduit {
    
    /// Singleton object.
    static let shared = SplitConduit()
    
    /// Updates when `UISplitViewController` shows / hides the primary view controller
    let primaryColumnChange = PassthroughSubject<Void, Never>()
    
    init(){}
}
