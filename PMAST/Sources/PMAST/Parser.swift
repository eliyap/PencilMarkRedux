//
//  MDAST.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import JavaScriptCore
import os.log

let ParseHandler = OSLog(subsystem: "com.pencilmark.parse", category: .pointsOfInterest)

final internal class Parser {
    
    static let shared = Parser()
    
    let context: JSContext = JSContext()!
    let url: URL = Bundle.module.url(forResource: "main", withExtension: "js")!
    
    init() {
        context.evaluateScript(try! String(contentsOf: url), withSourceURL: url)
    }
    
    func parse(_ markdown: String) -> [AnyHashable: Any] {
        /// Mark point of interest for profiling.
        /// Guide: https://www.donnywals.com/measuring-performance-with-os_signpost/
        os_signpost(.begin, log: ParseHandler, name: "Parse Markdown", "Begin Parse")
        defer { os_signpost(.end, log: ParseHandler, name: "Parse Markdown", "End Parse") }
        
        let result = context
            .objectForKeyedSubscript("PMJS")
            .objectForKeyedSubscript("parse")
            .call(withArguments: [markdown])
        
        #warning("Unsafe Unwrap!")
        let dict = result!.toDictionary()!
        return dict
    }
}

/// Constructs a Swift AST from:
/// - Parameters:
///   - dict: a JavaScript AST parsed from`text`
///   - text: the source Markdown text
/// - Important: `dict` **must** be the JS AST of `text`!
///
/// Since coercing the Swift AST from JS is cheap, this method allows us to make copies of a tree
/// easily without making a complex copying method, or re-incurring the parse cost.
func constructTree(from dict: [AnyHashable: Any], text: String) -> Root {
    let ast = Root(dict: dict, parent: nil, text: text)!
    
    /// assert tree is ok
    try! ast.linkCheck()
    
    return ast
}
