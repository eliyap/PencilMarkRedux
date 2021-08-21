//
//  Heading.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation

public final class Heading: Parent {
    
    override class var type: String { "heading" }
    
    let depth: Int
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?) {
        guard
            let depth = dict?["depth"] as? Int
        else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
        self.depth = depth
        super.init(dict: dict, parent: parent)
    }
    
    override func getReplacement() -> [Replacement] {
        var result: [Replacement] = []
        
        switch _leading_change {
        case .none:
            break
        case .toAdd:
            fatalError("Not Implemented!")
        case .toRemove:
            if let leading = leadingRange, let _ = trailingRange {
                result += [Replacement(range: leading, replacement: "")]
            } else {
                print("Requested replacement on Heading with no children!")
                
                /// return whole range to erase everything
                return [Replacement(range: position.nsRange, replacement: "")]
            }
        }
        
        switch _trailing_change {
        case .none:
            break
        case .toAdd:
            fatalError("Not Implemented!")
        case .toRemove:
            if let _ = leadingRange, let trailing = trailingRange {
                result += [Replacement(range: trailing, replacement: "")]
            } else {
                print("Requested replacement on Heading with no children!")
                
                /// return whole range to erase everything
                return [Replacement(range: position.nsRange, replacement: "")]
            }
        }
        
        return result
    }
}

