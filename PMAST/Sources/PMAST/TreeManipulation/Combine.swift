//
//  Combine.swift
//  
//
//  Created by Secret Asian Man Dev on 8/8/21.
//

import Foundation

extension Markdown {
    func combine() {
        /**
         A list of nodes, such that nodes that are adjacent in this list are also adjacent in the text,
         or will be once all changes are executed.
         */
        var adjacencyList: [Node] = []
        ast.build(&adjacencyList)
        
        guard adjacencyList.count >= 2 else { return }
        
        (0..<(adjacencyList.count - 2)).forEach { (i) in
            let curr = adjacencyList[i]
            let next = adjacencyList[i+1]
            guard
                curr != next,
                curr is InlineJoinable,
                next is InlineJoinable,
                curr._type == next._type
            else { return }
            
            switch curr._trailing_change {
            case .toAdd:
                curr._trailing_change = .none
            case .none:
                curr._trailing_change = .toRemove
            case .toRemove:
                fatalError("Unexpected state!")
            }
            
            switch next._leading_change {
            case .toAdd:
                next._leading_change = .none
            case .none:
                next._leading_change = .toRemove
            case .toRemove:
                fatalError("Unexpected state!")
            }
        }
    }
}

extension Node {
    func build(_ list: inout [Node]) -> Void {
        if let p = self as? Parent {
            /// represents leading syntax marks
            if _leading_change != .toRemove {
                list.append(self)
            }
            
            /// represents contents
            p.children.forEach { $0.build(&list) }
            
            /// represents trailing syntax marks
            if _trailing_change != .toRemove {
                list.append(self)
            }
        } else {
            /// represents contents
            if _content_change != .toRemove {
                list.append(self)
            }
        }
    }
}
