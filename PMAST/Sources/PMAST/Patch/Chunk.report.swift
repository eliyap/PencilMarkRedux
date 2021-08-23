//
//  Chunk.report.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

/// Custom debug printout.
internal extension CollectionDifference where ChangeElement == Chunk {
    
    /// Docs for `insert` and `remove`: https://developer.apple.com/documentation/swift/collectiondifference/change/insert_offset_element_associatedwith
    
    func report() -> Void {
        self.forEach { change in
            print("Chunk Change: ")
            switch change {
            case .insert(let offset, let element, let associatedWith):
                Self.report(offset: offset, element: element, associatedWith: associatedWith, symbol: "+")
            case .remove(let offset, let element, let associatedWith):
                Self.report(offset: offset, element: element, associatedWith: associatedWith, symbol: "-")
            }
        }
    }
    
    /// `offset`, `element`, `associatedWith`, from standard change parameters: https://developer.apple.com/documentation/swift/collectiondifference/change/insert_offset_element_associatedwith
    static func report(offset: Int, element: ChangeElement, associatedWith: Int?, symbol: Character) -> Void {
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
