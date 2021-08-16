//
//  Gesture.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/8/21.
//

import Foundation
import PencilKit

protocol Tutorial: CaseIterable {
    /// The gesture's name.
    var name: String { get }
    
    /// The URL for the video demonstrating the gesture.
    var url: URL { get }
    
    /// SF Symbol representing the gesture.
    var symbol: String { get }
}

enum Tool: Int, CaseIterable {
    case pencil
    case eraser
    
    var inkingTool: PencilKit.PKInkingTool {
        switch self {
        case .pencil:
            /**
             Use a blue color to make the tool stand out visually, especially in demo videos.
             Do not use ``tint``, whose orange is not distinct enough from the red rejection color.
             */
            return PKInkingTool(.pen, color: .systemBlue, width: 3)
        case .eraser:
            return PKInkingTool(.pen, color: .systemBlue, width: 3)
        }
    }
    
    var name: String {
        switch self {
        case .pencil:
            return "Pencil"
        case .eraser:
            return "Eraser"
        }
    }
    
    enum Pencil: Int, CaseIterable, Tutorial {
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
        
        var url: URL {
            switch self {
            case .strike:
                return Bundle.main.url(forResource: "Strike", withExtension: "mp4")!
            case .scribble:
                return Bundle.main.url(forResource: "Scribble", withExtension: "mp4")!
            }
        }
        
        var symbol: String {
            switch self {
            case .strike:
                return "strikethrough"
            case .scribble:
                return "scribble"
            }
        }
    }

    enum Eraser: Int, CaseIterable, Tutorial {
        case erase
        
        var name: String {
            switch self {
            case .erase:
                return "erase"
            }
        }
        
        var url: URL {
            switch self {
            case .erase:
                return Bundle.main.url(forResource: "Example", withExtension: "mp4")!
            }
        }
        
        var symbol: String {
            switch self {
            case .erase:
                #warning("Placeholder")
                return "xmark"
            }
        }
    }
}
