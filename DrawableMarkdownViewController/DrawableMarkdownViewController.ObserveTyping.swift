//
//  DrawableMarkdownViewController.ObserveTyping.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 24/7/21.
//

import Foundation
import UIKit
import Combine

extension DrawableMarkdownViewController {
    /// How long to wait between saving operations.
    static let period = 0.5
    
    /// Save very frequently when the user makes changes.
    func observeTyping() {
        let typing: AnyCancellable = model.typingC
            .throttle(for: .seconds(Self.period), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                if let document = self?.model.document {
                    document.save(to: document.fileURL, for: .forOverwriting) { (success) in
                        assert(document.documentState != UIDocument.State.savingError)
                        
                        if success == false {
                            AutoSave.log("""
                                Failed to Save
                                - fileURL: \(document.fileURL)
                                - localizedName: \(document.localizedName)
                                """)
                        } else {
                            AutoSave.log("Saved")
                        }
                    }
                }
            }
        store(typing)
    }
}
