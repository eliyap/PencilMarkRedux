//
//  Literal.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

class Literal: Content {
    
    class var type: String { "literal" }
    
    let text: String
    
    init?(dict: [AnyHashable: Any]?) {
        print(dict?.keys)
        guard let text = dict?["text"] as? String else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
        
        self.text = text
    }
}
