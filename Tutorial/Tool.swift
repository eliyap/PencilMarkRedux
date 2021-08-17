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
}
