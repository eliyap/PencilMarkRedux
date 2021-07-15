//
//  Node_Construct.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 12/7/21.
//

import Foundation

/// Creates the appropriate ``Content`` subclass based on the reported type.
/// - Parameters:
///   - dict: JavaScript Object Dictionary
///   - parent: the node to assign as the parent
func construct(from dict: [AnyHashable: Any]?, parent: Parent?) -> Node? {
    let type = dict?["type"] as? String
    switch type {
    case Heading.type:
        return Heading(dict: dict, parent: parent)
    case Root.type:
        return Root(dict: dict, parent: parent)
    case ThematicBreak.type:
        return ThematicBreak(dict: dict, parent: parent)
    case List.type:
        return List(dict: dict, parent: parent)
    case ListItem.type:
        return ListItem(dict: dict, parent: parent)
    case Paragraph.type:
        return Paragraph(dict: dict, parent: parent)
    case Delete.type:
        return Delete(dict: dict, parent: parent)
    case Strong.type:
        return Strong(dict: dict, parent: parent)
    case Emphasis.type:
        return Emphasis(dict: dict, parent: parent)
    case Text.type:
        return Text(dict: dict, parent: parent)
    default:
        print("Unrecognized type \(type ?? "No Type")")
        print("\(String(describing: dict?.keys))")
        return nil
    }
}
