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
        
        (0..<(adjacencyList.count - 2)).forEach { (i) in
            let curr = adjacencyList[i]
            let next = adjacencyList[i+1]
            guard
                curr != next,
                curr is InlineJoinable,
                next is InlineJoinable
            else { return }
            print("Adjacent!")
        }
    }
}

extension Node {
    func build(_ list: inout [Node]) -> Void {
        if let p = self as? Parent {
            /// represents leading syntax marks
            if _change != .toRemove {
                list.append(self)
            }
            
            /// represents contents
            p.children.forEach { $0.build(&list) }
            
            /// represents trailing syntax marks
            if _change != .toRemove {
                list.append(self)
            }
        } else {
            /// represents contents
            if _change != .toRemove {
                list.append(self)
            }
        }
    }
}
