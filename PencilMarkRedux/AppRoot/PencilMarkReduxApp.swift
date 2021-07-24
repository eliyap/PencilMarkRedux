//
//  PencilMarkReduxApp.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import SwiftUI

//@main
struct PencilMarkReduxApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: StyledMarkdown()) { file in
            ContentView(document: file.$document)
        }
    }
}
