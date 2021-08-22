//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 22/8/21.
//

import Foundation

extension Markdown {
    #warning("⚠️ UNDER CONSTRUCTION ⚠️")
    func diffChunks(with new: String) -> Void {
        let original = getChunks(in: plain.makeLines())
        let other = getChunks(in: new.makeLines())
        
        print("Chunks: \(original)")
        
        let diff = original.difference(from: other)
        print(diff)
        diff.report()
    }
}
