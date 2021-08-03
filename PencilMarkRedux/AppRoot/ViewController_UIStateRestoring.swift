//
//  ViewController_UIStateRestoring.swift
//  ViewController_UIStateRestoring
//
//  Created by Secret Asian Man Dev on 1/8/21.
//

import UIKit

// MARK: - State Restoration
extension ViewController {
    
    override var restorationIdentifier: String? {
        get { "PMRootViewController" }
        set { assert(false, "Restoration ID set to \(newValue ?? "")") }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        print("Encoding " + "\(#file), \(#function), Line \(#line)")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        print("Decoding " + "\(#file), \(#function), Line \(#line)")
    }
}
