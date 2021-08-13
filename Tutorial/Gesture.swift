//
//  Gesture.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/8/21.
//

import Foundation

enum Gesture: Int, CaseIterable {
    case strike
    case scribble
    
    var name: String {
        switch self {
        case .strike:
            return "Strike"
        case .scribble:
            return "Scribble"
        }
    }
    
    /// The URL for the video demonstrating the gesture.
    var url: URL {
        switch self {
        case .strike:
            return Bundle.main.url(forResource: "Strike", withExtension: "mp4")!
        case .scribble:
            return Bundle.main.url(forResource: "Scribble", withExtension: "mp4")!
        }
    }
    
    /// SF Symbol representing the gesture.
    var symbol: String {
        switch self {
        case .strike:
            return "strikethrough"
        case .scribble:
            return "scribble"
        }
    }
}

