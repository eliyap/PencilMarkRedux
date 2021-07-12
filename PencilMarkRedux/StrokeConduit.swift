//
//  StrokeConduit.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import PencilKit

final class StrokeConduit: ObservableObject {
    @Published var stroke: PKStroke? = nil
}
