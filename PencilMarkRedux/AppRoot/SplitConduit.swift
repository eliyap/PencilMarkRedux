//
//  SplitConduit.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 13/8/21.
//

import Combine

final class SplitConduit {
    static let shared = SplitConduit()
    
    /// Updates when `UISplitViewController` shows / hides the primary view controller
    let primaryColumnChange = PassthroughSubject<Void, Never>()
    
    init(){}
}
