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
    
    let category: String
    let enabled: Bool
    let logger: Logger
    
    init(category: String, enabled: Bool) {
        self.category = category
        self.enabled = enabled
        self.logger = Logger(subsystem: Self.AppSystem, category: category)
    }
    
    func log<S: CustomStringConvertible>(_ s: S) -> Void {
        logger.log(level: .info, "\(s)")
    }
    
    func print<S: CustomStringConvertible>(_ s: S) -> Void {
        logger.log(level: .debug, "\(s)")
    }
}

/// Persists app state across launches.
let SceneRestoration = PMLogger(category: "SceneRestoration", enabled: true)

/// Persists document text to disk.
let AutoSave = PMLogger(category: "AutoSave", enabled: true)

/// `UIDocument` subclass.
let SMDocument = PMLogger(category: "SMDocument", enabled: true)

/// Monitor document events.
let FileSystem = PMLogger(category: "FileSystem", enabled: true)
