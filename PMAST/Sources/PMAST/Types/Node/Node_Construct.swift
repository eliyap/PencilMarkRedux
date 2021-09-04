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
func construct(from dict: [AnyHashable: Any]?, parent: Parent?, text: String) -> Node? {
    let type = dict?["type"] as? String
    switch type {
    case Heading.type:
        return Heading(dict: dict, parent: parent, text: text)
    case Root.type:
        return Root(dict: dict, parent: parent, text: text)
    case ThematicBreak.type:
        return ThematicBreak(dict: dict, parent: parent, text: text)
    case Blockquote.type:
        return Blockquote(dict: dict, parent: parent, text: text)
    case Code.type:
        return Code(dict: dict, parent: parent, text: text)
    case InlineCode.type:
        return InlineCode(dict: dict, parent: parent, text: text)
    case Image.type:
        return Image(dict: dict, parent: parent, text: text)
    case Link.type:
        return Link(dict: dict, parent: parent, text: text)
    case List.type:
        return List(dict: dict, parent: parent, text: text)
    case ListItem.type:
        return ListItem(dict: dict, parent: parent, text: text)
    case Paragraph.type:
        return Paragraph(dict: dict, parent: parent, text: text)
    case Delete.type:
        return Delete(dict: dict, parent: parent, text: text)
    case Strong.type:
        return Strong(dict: dict, parent: parent, text: text)
    case Mark.type:
        return Mark(dict: dict, parent: parent, text: text)
    case Emphasis.type:
        return Emphasis(dict: dict, parent: parent, text: text)
    case Text.type:
        return Text(dict: dict, parent: parent, text: text)
    case Node.type, Parent.type, Literal.type:
        fatalError("Tried to instantiate abstract type!")
    default:
        print("Unrecognized type \(type ?? "No Type")")
        print("\(String(describing: dict?.keys))")
        return nil
    }
}
