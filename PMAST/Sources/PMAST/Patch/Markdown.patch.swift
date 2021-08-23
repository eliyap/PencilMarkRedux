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
        
        let diff = oldChunks.difference(from: newChunks)
        diff.report()
    }
}
