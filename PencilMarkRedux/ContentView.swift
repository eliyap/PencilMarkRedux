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
    
    @State var hideBar = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GeometryReader { geo in
                HStack {
                    Spacer()
                        .frame(maxWidth: geo.size.width * 0.1)
                    ZStack {
//                        KeyboardEditorView(strokeC: strokeC, frameC: frameC, cmdC: cmdC, document: $document)
                        CanvasView(strokeC: strokeC, frameC: frameC, cmdC: cmdC)
                    }
                    Spacer()
                        .frame(maxWidth: geo.size.width * 0.1)
                }
            }
            Button { withAnimation { hideBar.toggle() } } label: {
                SwiftUI.Image(systemName: hideBar
                    ? "arrow.down.right.and.arrow.up.left.circle.fill"
                    : "arrow.up.backward.and.arrow.down.forward.circle.fill"
                )
                    .font(.title)
                    .foregroundColor(.secondary)
            }
                .padding()
        }
            .navigationBarHidden(hideBar)
    }
}

