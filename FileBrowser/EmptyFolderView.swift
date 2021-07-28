//
//  EmptyFolderView.swift
//  SplitControl
//
//  Created by Secret Asian Man Dev on 22/7/21.
//

import Foundation
import SwiftUI

/**
 Wraps a hosted SwiftUI View in a `UIScrollView` so that, like a `UITableView`,
 we can expose a `UIRefreshController` and the user can refresh the data with the same gesture.
 */
final class EmptyFolderViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let hosted = EmptyFolderHost()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        /// Adopt and control `UIScrollView`
        view = scrollView
        
        /// Allow scrolling even when content is too small (i.e. when SwiftUI View is shown).
        scrollView.alwaysBounceVertical = true
        
        /// Refresh on pull.
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        /// Make area behind `scrollView` seamless with the `scollView` itself.
        view.backgroundColor = .systemBackground
        
        /// Add subview
        adopt(hosted)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use")
    }
    
    /// Update `SwiftUI` constraints when view appears.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hosted.view.frame = view.frame
        
        /// Note: do **not** set frame for all subviews, as this breaks the refresh indicator layout for `UIRefreshController`.
    }
    
    @objc
    func refresh() {
        /// Always stop refresh animation
        defer {
            DispatchQueue.main.async {
                self.scrollView.refreshControl?.endRefreshing()
            }
        }
        
        /// Trigger data refresh in sibling view
        guard let parent = parent as? FolderViewController else {
            assert(false, "Parent of unexpected type!")
        }
        parent.filesView.refresh()
    }
}

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
