//
//  MDAST.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import JavaScriptCore

final internal class Parser {
    
    static let shared = Parser()
    
    let context: JSContext = JSContext()!
    let url: URL = Bundle.module.url(forResource: "main", withExtension: "js")!
    
    init() {
        context.evaluateScript(try! String(contentsOf: url), withSourceURL: url)
    }
    
    func parse(markdown: String) -> Root {
        let result = context
            .objectForKeyedSubscript("PMJS")
            .objectForKeyedSubscript("parse")
            .call(withArguments: [markdown])
        
        #warning("Unsafe Unwrap!")
        let dict = result!.toDictionary()!
        
        let ast = Root(dict: dict, parent: nil)!
        
        /// assert tree is ok
        try! ast.linkCheck()
        
        return ast
        
    }
}
