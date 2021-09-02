//
//  Tool.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/8/21.
//

import Foundation
import PencilKit

enum Tool: Int, CaseIterable {
    case pencil
    case eraser
    #if HIGHLIGHT_ENABLED
    case highlighter
    #endif
    
    var inkingTool: PencilKit.PKInkingTool {
        switch self {
        case .pencil:
            /**
             Use a blue color to make the tool stand out visually, especially in demo videos.
             Do not use ``tint``, whose orange is not distinct enough from the red rejection color.
             */
            return PKInkingTool(.pen, color: .systemBlue, width: 3)
        case .eraser:
            return PKInkingTool(.pen, color: .clear, width: 0)
        #if HIGHLIGHT_ENABLED
        case .highlighter:
            return PKInkingTool(.pen, color: .clear, width: 0)
        #endif
        }
    }
    
    var name: String {
        switch self {
        case .pencil:
            return "Pencil"
        case .eraser:
            return "Eraser"
        #if HIGHLIGHT_ENABLED
        case .highlighter:
            return "Highlighter"
        #endif
        }
    }
    
    var style: LineFragment.Style {
        switch self {
        case .pencil:
            return [:]
        case .eraser:
            return [.foregroundColor: UIColor.red]
        #if HIGHLIGHT_ENABLED
        case .highlighter:
            return [.backgroundColor: UIColor.yellow.withAlphaComponent(0.5)]
        #endif
        }
    }
}
