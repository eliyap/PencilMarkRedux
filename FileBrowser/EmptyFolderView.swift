//
//  EmptyFolderView.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 22/7/21.
//

import Foundation
import SwiftUI

final class EmptyFolderHost: UIHostingController<EmptyFolderView> {
    init() {
        super.init(rootView: EmptyFolderView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
}

/// Placeholder view showing that a folder is empty.
struct EmptyFolderView: View {
    var body: some View {
        VStack {
            SwiftUI.Image(systemName: "tray")
                .font(.largeTitle)
            SwiftUI.Text("Empty")
        }
            .foregroundColor(.secondary)
    }
}
