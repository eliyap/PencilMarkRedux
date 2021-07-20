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
        GeometryReader { geo in
            HStack {
                Spacer()
                    .frame(maxWidth: geo.size.width * 0.1)
                ZStack {
                    KeyboardEditorView(strokeC: strokeC, frameC: frameC, cmdC: cmdC, document: $document)
                    CanvasView(strokeC: strokeC, frameC: frameC, cmdC: cmdC)
                }
                Spacer()
                    .frame(maxWidth: geo.size.width * 0.1)
            }
        }
    }
}

