//
//  iCloudBrokenView.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 22/7/21.
//

import SwiftUI

final class iCloudBrokenHost: UIHostingController<iCloudBrokenView> {
    init() {
        super.init(rootView: iCloudBrokenView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
}

/// Placeholder view showing that we could not access iCloud.
struct iCloudBrokenView: View {
    var body: some View {
        VStack {
            SwiftUI.Image(systemName: "icloud.slash")
                .font(.largeTitle)
            SwiftUI.Text("Could not access iCloud")
        }
            .foregroundColor(.secondary)
    }
}
