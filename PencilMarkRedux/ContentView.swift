//
//  ContentView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var strokeC = StrokeConduit()
    let mdast: MDAST = MDAST.shared
    
    var body: some View {
        ZStack {
            KeyboardEditorView(strokeC: strokeC)
                .border(Color.red)
            CanvasView(strokeC: strokeC)
                .border(Color.red)
        }
        .onAppear {
            mdast.parse(markdown: "# TEST")
        }
    }
}

