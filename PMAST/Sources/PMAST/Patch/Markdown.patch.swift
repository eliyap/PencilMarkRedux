//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

extension Markdown {
    public mutating func patch(with new: String) {
        #warning("Not Implemented!")
        let oldChunks = plain.makeLines().chunked()
        let newChunks = new.makeLines().chunked()
        
        let diff = newChunks.difference(from: oldChunks)
        diff.report()
        
        diff.forEach { change in
            switch change {
            case .insert(let offset, let element, let associatedWith):
                print("Contents: \(new.contents(of: element))")
                let node = Parser.shared.parse(markdown: new.contents(of: element))
                #warning("TODO: insert this into tree")
            case .remove(let offset, let element, let associatedWith):
                break
            }
        }
    }
}
