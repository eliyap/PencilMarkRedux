//
//  _DrawableMarkdownViewController.ObserveTyping.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Foundation
import UIKit
import Combine

extension _DrawableMarkdownViewController {
    /// How long to wait between saving operations.
    static let period = 0.5
    
    /// Save very frequently when the user makes changes.
    func observeTyping() {
        document.ticker
            .throttle(for: .seconds(Self.period), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] in
                if let document = self?.document {
                    document.save(to: document.fileURL, for: .forOverwriting) { (success) in
                        if success == false {
                            print("Failed to save!")
                        }
                    }
                }
            }
            .store(in: &observers)
    }
}
