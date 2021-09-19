//
//  FileBrowser.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 19/9/21.
//

import UIKit

/// Shell for all FileBrowser classes.
enum FileBrowser {
    static var iCloudURL: URL? {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)?
            .appendingPathComponent("Documents")
    }
}