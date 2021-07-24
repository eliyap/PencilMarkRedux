//
//  DrawableMarkdownViewController.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 23/7/21.
//

import Foundation
import UIKit
import Combine

final class DrawableMarkdownViewController: UIViewController {

    /// File URL of the open document.
    private let url: URL
    
    let strokeC = StrokeConduit()
    let frameC = FrameConduit()
//    let cmdC = CommandConduit()
//    let document: StyledMarkdown
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not use")
    }
}
