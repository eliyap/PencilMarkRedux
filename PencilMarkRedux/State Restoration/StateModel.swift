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
    
    var url: URL? = nil
}
