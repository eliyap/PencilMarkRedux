//
//  PMCanvasView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 16/7/21.
//

import Foundation
import PencilKit

final class PMCanvasView: PKCanvasView {
    /// Currently a no-op
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        switch touch.type {
        case .direct:
            break
        default:
            break
        }
    }
}
