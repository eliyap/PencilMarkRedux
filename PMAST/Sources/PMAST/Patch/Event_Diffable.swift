//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 23/8/21.
//

import Foundation

extension Event: Diffable {
    static func report(offset: Int, element: Event, associatedWith: Int?, symbol: Character) {
        var result = "   (\(symbol))" /// padding
        result += "\(offset)".padding(toLength: 3, withPad: " ", startingAt: 0) + ":"
        switch element {
        case .enter(let point, let type):
            result += "🔽@\(point): \(type)"
        case .exit(let point, let type):
            result += "🔼@\(point): \(type)"
        case .contents(let value):
            result += "⏺: \(value)"
        }
        print(result)
    }
}
