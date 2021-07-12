//
//  MDAST.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import JavaScriptCore

final class Parser {
    
    public static let shared = Parser()
    
    let context: JSContext = JSContext()!
    let url: URL = Bundle.main.url(forResource: "main", withExtension: "js")!
    
    init() {
        context.evaluateScript(try! String(contentsOf: url), withSourceURL: url)
    }
    
    func parse(markdown: String) -> Void {
        let result = context
            .objectForKeyedSubscript("PMJS")
            .objectForKeyedSubscript("parse")
            .call(withArguments: [markdown])
        
        #warning("Unsafe Unwrap!")
        let dict = result!.toDictionary()!
        
        let root = Root(dict: dict)!
        root.walk()
    }
}
