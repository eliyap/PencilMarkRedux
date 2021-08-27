//
//  Tool.Eraser.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 16/8/21.
//

import Foundation

extension Tool {
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
                return Bundle.main.url(forResource: "Eraser", withExtension: "mp4")!
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
