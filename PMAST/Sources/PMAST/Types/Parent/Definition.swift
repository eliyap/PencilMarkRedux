//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 19/9/21.
//

import Foundation

public final class Definition: Node, Resource, Association {
    class override var type: String { "definition" }
    
    /// `Resource`
    var url: String
    var title: String?
    
    /// `Association`
    var identifier: String
    var label: String?
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?, text: String) {
        guard
            let url = dict?["url"] as? String,
            let identifier = dict?["identifier"] as? String
        else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
        self.url = url
        self.identifier = identifier
        self.title = dict?["title"] as? String
        self.label = dict?["label"] as? String
        super.init(dict: dict, parent: parent, text: text)
        print(dict)
    }
    
    required init(_ node: Node, parent: Parent!) {
        let definition = (node as! Self)
        url = definition.url
        title = definition.title
        identifier = definition.identifier
        label = definition.label
        super.init(node, parent: parent)
    }
}
