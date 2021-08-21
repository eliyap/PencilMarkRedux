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
    
    func parse(markdown: String) -> Root {
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
        
        let ast = Root(dict: dict, parent: nil)!
        
        /// assert tree is ok
        try! ast.linkCheck()
        
        // WIP: find actual top level node boundaries.
        let actual: [Chunk] = ast.children.map {
            Chunk(start: $0.position.start, end: $0.position.end)
        }
        
        let lines = OptionalArray(markdown.makeLines())
        (lines.startIndex..<lines.endIndex).forEach { idx in
            let line = lines[idx]!
            
            /// Skip blank lines,
            guard line.string.isBlank == false else { return }
            
            /// Checks if preceding line is blank.
            let isPrecedingBlank = lines[idx - 1]?.string.isBlank ?? true
            
            if isPrecedingBlank && (line.string.isPotentiallyContinuation == false) {
                print("Chunk Boundary: Line \(idx)")
            }
        }
        
        return ast
    }
}

struct PMAbstractSyntaxTree {
    let root: Root
    let chunks: [Chunk]
    
    
}

struct Chunk {
    var start: Point
    var end: Point
}

/// Simple way to avoid crashing out of bounds errors.
struct OptionalArray<T> {
    
    private var array: [T]
    
    init(_ array: [T]) {
        self.array = array
    }
    
    /// Make struct transparent to underlying array.
    var startIndex: Int { array.startIndex }
    var endIndex: Int { array.endIndex }
    
    /// The core of the struct, performs a safety check and returns nil if unsafe.
    subscript(idx: Int) -> T? {
        array.startIndex <= idx && idx < array.endIndex
            ? array[idx]
            : nil
    }
}
