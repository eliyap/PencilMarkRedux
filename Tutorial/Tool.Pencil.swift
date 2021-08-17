//
//  Tool.Pencil.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 16/8/21.
//

import Foundation

extension Tool {
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
}
