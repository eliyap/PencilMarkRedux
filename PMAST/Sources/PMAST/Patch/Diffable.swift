//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 23/8/21.
//

import Foundation

protocol Diffable {
    /// Print out your changes as desired here.
    /// ``symbol`` is either `+` or `-` for insert and remove respectively.
    ///
    /// `offset`, `element`, `associatedWith`, from standard change parameters
    /// Docs: https://developer.apple.com/documentation/swift/collectiondifference/change/insert_offset_element_associatedwith
    static func report(offset: Int, element: Self, associatedWith: Int?, symbol: Character) -> Void
}

/// Custom debug printout.
internal extension CollectionDifference where ChangeElement: Diffable {
    
    /// Generate a human readable difference report.
    /// Primarily for debugging purposes.
    /// Docs for `insert` and `remove`: https://developer.apple.com/documentation/swift/collectiondifference/change/insert_offset_element_associatedwith
    func report() -> Void {
        self.forEach { change in
            switch change {
            case .insert(let offset, let element, let associatedWith):
                ChangeElement.report(offset: offset, element: element, associatedWith: associatedWith, symbol: "+")
            case .remove(let offset, let element, let associatedWith):
                ChangeElement.report(offset: offset, element: element, associatedWith: associatedWith, symbol: "-")
            }
        }
    }
}
