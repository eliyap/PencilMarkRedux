//
//  FrameConduit.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 16/7/21.
//

import Foundation
import CoreGraphics

/// Combine conduit for passing view frame `CGRect`s between `UIKit` views.
final class FrameConduit: ObservableObject {
    @Published var contentSize: CGSize? = nil
}
