//
//  NoDocumentView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 25/7/21.
//

import SwiftUI

final class NoDocumentHost: UIHostingController<NoDocumentView> {
    init() {
        super.init(rootView: NoDocumentView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
}

/// Placeholder view showing that we could not access iCloud.
struct NoDocumentView: View {
    var body: some View {
        VStack {
            SwiftUI.Image(systemName: "doc.text.magnifyingglass")
                .font(.largeTitle)
            SwiftUI.Text("No Document Open")
        }
            .foregroundColor(.secondary)
    }
}
