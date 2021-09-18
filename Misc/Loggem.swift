//
//  Loggem.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/9/21.
//

import Foundation
import OSLog

/// Docs: https://developer.apple.com/documentation/os/logging/generating_log_messages_from_your_code
internal class PMLogger {
    
    static let AppSystem = "md.pencil"
    
    let subsystem: String
    let enabled: Bool
    let logger: Logger
    
    init(name: String, enabled: Bool) {
        self.subsystem = Self.AppSystem + name
        self.enabled = enabled
        self.logger = Logger(subsystem: subsystem, category: "")
    }
    
    func log<S: CustomStringConvertible>(_ s: S) -> Void {
        logger.log(level: .info, "\(s)")
    }
    
    func print<S: CustomStringConvertible>(_ s: S) -> Void {
        logger.log(level: .debug, "\(s)")
    }
}

let SceneRestoration = PMLogger(name: "SceneRestoration", enabled: true)
