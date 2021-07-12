//
//  Text.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

final class Text: Node {
    override class var type: String { "text" }
}

extension Node {
    func split(on range: NSRange, with styled: Node) -> (Text, Text, Text) {
        let prefix: Text = Text(
            dict: [
                "position": [
                    "start": [
                        "line": position.start.line,
                        "column": position.start.column,
                        "offset": position.start.offset,
                    ],
                    "end": [
                        "line": position.end.line,
                        "column": position.end.column,
                        "offset": range.lowerBound,
                    ],
                ],
                "type": Text.type,
                "children": [],
            ],
            parent: self
        )!
        let middle: Text = Text(
            dict: [
                "position": [
                    "start": [
                        "line": position.start.line,
                        "column": position.start.column,
                        "offset": range.lowerBound,
                    ],
                    "end": [
                        "line": position.end.line,
                        "column": position.end.column,
                        "offset": range.upperBound,
                    ],
                ],
                "type": Text.type,
                "children": [],
            ],
            parent: styled
        )!
        let suffix: Text = Text(
            dict: [
                "position": [
                    "start": [
                        "line": position.start.line,
                        "column": position.start.column,
                        "offset": range.upperBound,
                    ],
                    "end": [
                        "line": position.end.line,
                        "column": position.end.column,
                        "offset": position.nsRange.upperBound,
                    ],
                ],
                "type": Text.type,
                "children": [],
            ],
            parent: self
        )!
        
        return (
            prefix,
            middle,
            suffix
        )
    }
}
