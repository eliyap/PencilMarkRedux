//
//  ContentView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var strokeC = StrokeConduit()
    @State var document = StyledMarkdown(text: """
# 21.06.21
### OMM
Lab Meeting
- [x] Amazon ~~Package~~ o/
MR4 **Reading** DO IT
An *emphasis* on hope
A _**Strong Emphasis**_ on love
""")
    var body: some View {
        ZStack {
            KeyboardEditorView(strokeC: strokeC, document: $document)
                .border(Color.red)
            CanvasView(strokeC: strokeC)
                .border(Color.red)
        }
    }
}

