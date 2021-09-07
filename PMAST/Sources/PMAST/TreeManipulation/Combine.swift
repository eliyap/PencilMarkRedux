//
//  Combine.swift
//  
//
//  Created by Secret Asian Man Dev on 8/8/21.
//

import Foundation

extension Markdown {
    /**
     Attempt to "combine" directly adjacent elements to avoid incorrect syntax.
     e.g. `~~strike~~~~me~~` should become `~~strikeme~~`
     This is achieved by marking the trailing edge or the former and the leading edge of the latter for deletion.
     - Warning: This is essentially an elaborate hack, and leaves the AST in an even stranger state than usual.
                Therefore it should probably be called last before `makeReplacements`.
     */
    func combine() {
        /**
         A list of nodes, such that nodes that are adjacent in this list are also adjacent in the text,
         or will be once all changes are executed.
         */
        var adjacencyList: [Node] = []
        ast.build(&adjacencyList)
        
        /// Flags whether we did combine something.
        var tripped = false
        
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
            
            tripped = true
            
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
        
        /// If we remove some stuff, that might expose more joinable elements, so recursively check again.
        if tripped { combine() }
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
