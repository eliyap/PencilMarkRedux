//
//  Position.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

public struct Position {
    var start: Point
    var end: Point

    var length: Int {
        end.offset - start.offset
    }
    
    public var nsRange: NSRange {
        NSMakeRange(start.offset, length)
    }
    
    init?(dict: [AnyHashable: Any]?) {
        guard
            let dict = dict,
            let start = Point(dict: dict["start"] as? [AnyHashable: Any]),
            let end = Point(dict: dict["end"] as? [AnyHashable: Any])
        else {
            print("Failed to initialize \(Self.self)")
            return nil
        }
        
        self.init(start: start, end: end)
    }

    init (
        start: Point,
        end: Point
    ) {
        self.start = start
        self.end = end
    }
}

extension Position: Equatable {
    public static func == (lhs: Position, rhs: Position) -> Bool {
        lhs.start == rhs.start && lhs.end == rhs.end
    }
}

extension Position: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(start)
        hasher.combine(end)
    }
}
