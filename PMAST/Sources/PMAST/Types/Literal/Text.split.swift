//
//  Text.split.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 15/7/21.
//

import Foundation

extension Text {
    /**
     Constructs three text nodes with
     - text before the intersection between `range` and own contents (may be nil)
     - text within the intersection between `range` and own contents (never nil)
     - text after the intersection between `range` and own contents (may be nil)
     - ``parent`` is set to `nil`, calling function should decide where to attach these nodes!
     */
    func split(on range: NSRange) -> (Text?, Text, Text?) {
        
        /// get range's intersection with own range
        let intersection = range.intersection(with: position.nsRange)
        
        var (prefix, suffix): (Text?, Text?) = (nil, nil)
        var middle: Text
        
        /// Check non empty range to avoid inserting empty text nodes, which mess up ``consume``.
        if position.start.offset < intersection.lowerBound {
            prefix = Text(
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
                            "offset": intersection.lowerBound,
                        ],
                    ],
                    "type": Text.type,
                    "value": "", /// NOTHING!
                ],
                parent: nil
            )
        }
        
        middle = Text(
            dict: [
                "position": [
                    "start": [
                        "line": position.start.line,
                        "column": position.start.column,
                        "offset": intersection.lowerBound,
                    ],
                    "end": [
                        "line": position.end.line,
                        "column": position.end.column,
                        "offset": intersection.upperBound,
                    ],
                ],
                "type": Text.type,
                "value": "", /// NOTHING!
            ],
            parent: nil
        )! /// force unwrap!
        
        /// Check non empty range to avoid inserting empty text nodes, which mess up ``consume``.
        if intersection.upperBound < position.nsRange.upperBound {
            suffix = Text(
                dict: [
                    "position": [
                        "start": [
                            "line": position.start.line,
                            "column": position.start.column,
                            "offset": intersection.upperBound,
                        ],
                        "end": [
                            "line": position.end.line,
                            "column": position.end.column,
                            "offset": position.nsRange.upperBound,
                        ],
                    ],
                    "type": Text.type,
                    "value": "", /// NOTHING!
                ],
                parent: nil
            )
        }
        
        return (
            prefix,
            middle,
            suffix
        )
    }
}
