//
//  CommandConduit.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 18/7/21.
//

import Foundation
import Combine

/// A `Combine` conduit for keyboard commands and the like between Canvas and Text views.
struct CommandConduit {
    let undo = PassthroughSubject<Void, Never>()
    let redo = PassthroughSubject<Void, Never>()
}
