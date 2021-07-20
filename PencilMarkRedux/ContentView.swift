//
//  ContentView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var strokeC = StrokeConduit()
    @StateObject var frameC = FrameConduit()
    let cmdC = CommandConduit()
    @Binding var document: StyledMarkdown
    
    var body: some View {
        ZStack {
            KeyboardEditorView(strokeC: strokeC, frameC: frameC, cmdC: cmdC, document: $document)
            CanvasView(strokeC: strokeC, frameC: frameC, cmdC: cmdC)
        }
    }
}

