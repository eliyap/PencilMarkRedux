//
//  ContentView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            KeyboardEditorView()
                .border(Color.red)
            CanvasView()
                .border(Color.red)
        }
        
    }
}

