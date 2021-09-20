//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 19/9/21.
//

import Foundation

public final class LinkReference: Node, Reference {
    
    override class var type: String { "linkReference" }
    
    /// `Reference`
    var identifier: String
    var label: String?
    var referenceType: ReferenceType
    
    required init?(dict: [AnyHashable: Any]?, parent: Parent?, text: String) {
        guard
            let identifier = dict?["identifier"] as? String,
            let referenceString = dict?["referenceType"] as? String,
            let referenceType = ReferenceType(rawValue: referenceString)
        else {
            print("Failed to initialize \(Self.type)")
            return nil
        }
        self.identifier = identifier
        self.label = dict?["label"] as? String
        self.referenceType = referenceType
        super.init(dict: dict, parent: parent, text: text)
    }
    
    /// Deep Copy Constructor.
    required init(_ node: Node, parent: Parent!) {
        let linkReference = (node as! Self)
        identifier = linkReference.identifier
        label = linkReference.label
        referenceType = linkReference.referenceType
        super.init(node, parent: parent)
    }
    
    
}
