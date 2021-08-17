//
//  Tutorial.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 16/8/21.
//

import Foundation

/// Something that provides values to populate our tutorial system.
protocol Tutorial: CaseIterable {
    /// The gesture's name.
    var name: String { get }
    
    /// The URL for the video demonstrating the gesture.
    var url: URL { get }
    
    /// SF Symbol representing the gesture.
    var symbol: String { get }
}
