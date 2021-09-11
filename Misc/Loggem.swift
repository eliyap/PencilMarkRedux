//
//  Loggem.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/9/21.
//

import Foundation

protocol Logger {
    /// Subsystem name.
    static var name: String { get }
    
    /// Whether this logger is enabled.
    static var enabled: Bool { get }
    
    /// Print function.
    static func log<S: CustomStringConvertible>(_ s: S) -> Void
}

/// Default implementation
extension Logger {
    static func log<S: CustomStringConvertible>(_ s: S) -> Void {
        if enabled {
            print(name, s)
        }
    }
}

enum SceneRestoration: Logger {
    static var name: String { "SceneRestoration" }
    static var enabled: Bool { true }
}
