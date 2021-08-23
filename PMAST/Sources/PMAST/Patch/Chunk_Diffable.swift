//
//  Chunk.report.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

extension Chunk: Diffable {
    /// `offset`, `element`, `associatedWith`, from standard change parameters: https://developer.apple.com/documentation/swift/collectiondifference/change/insert_offset_element_associatedwith
    static func report(offset: Int, element: Self, associatedWith: Int?, symbol: Character) -> Void {
        print("Chunk Change: ")
        (element.startIndex..<element.endIndex).forEach { idx in
            /// Format something like this:
            /// (+) 12: "new line!"
            print(
                "   ", /// padding
                "(\(symbol))",
                "\(idx)".padding(toLength: 3, withPad: " ", startingAt: 0) + ":", /// make line length uniform up to 999 lines
                "\"\(element[idx].string)\""
            )
        }
    }
}
