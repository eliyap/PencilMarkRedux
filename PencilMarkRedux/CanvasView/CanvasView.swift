//
//  CanvasView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import SwiftUI
struct CanvasView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = CanvasViewController
    
    let strokeC: StrokeConduit
    let frameC: FrameConduit
    let cmdC: CommandConduit
    
    func makeUIViewController(context: Context) -> CanvasViewController {
        let vc = UIViewControllerType(coordinator: context.coordinator, frameC: frameC)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CanvasViewController, context: Context) {
        /// nothing
    }
}

