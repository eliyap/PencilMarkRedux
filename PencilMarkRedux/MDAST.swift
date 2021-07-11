//
//  MDAST.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import Foundation
import JavaScriptCore

final class MDAST {
    
    public static let shared = MDAST()
    
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
        print(result)
    }
}
