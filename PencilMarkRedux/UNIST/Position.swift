//
//  Position.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

struct Position {
    let start: Point
    let end: Point

    init?(dict: [AnyHashable: Any]?) {
        guard
            let dict = dict,
            let start = Point(dict: dict["start"] as? [AnyHashable: Any]),
            let end = Point(dict: dict["end"] as? [AnyHashable: Any])
        else {
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

