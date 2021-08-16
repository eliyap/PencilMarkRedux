//
//  StateModel.swift
//  StateModel
//
//  Created by Secret Asian Man Dev on 3/8/21.
//

import Foundation

final class StateModel {
    static let shared: StateModel = {
        let instance = StateModel()
        return instance
    }()
    
    /// URL of open document.
    /// By default, no document is open
    var url: URL? = nil
    
    /// User's active tool.
    /// By default, the `pencil` is used.
    var tool: Tool = .pencil
}
