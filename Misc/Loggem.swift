//
//  Loggem.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/9/21.
//

import Foundation

protocol Logger {
    /// Whether this logger is enabled.
    static var enabled: Bool { get }
    
    /// Print function.
    static func log<S: CustomStringConvertible>(_ s: S) -> Void
}

/// Default implementation
extension Logger {
    static func log<S: CustomStringConvertible>(_ s: S) -> Void {
        if enabled {
            print(s)
        }
    }
}

enum SceneRestoration: Logger {
    static var enabled: Bool { true }
}
