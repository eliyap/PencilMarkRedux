//
//  Paragraph.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

public class Paragraph: Parent, LeafBlock {
    override class var type: String { "paragraph" }
    
    override public var description: [Event] {
        childDescriptions /// suppress ``Paragraph`` descriptions!
    }
}
