//
//  SplitConduit.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 13/8/21.
//

import Combine

/**
 Singleton class that passes through notifications when `UISplitViewController` has layout changes.
 */
final class SplitConduit {
    
    /// Singleton object.
    static let shared = SplitConduit()
    
    /** 21.08.13
     Observed issue:
     - `viewWillLayoutSubviews` should pass in updated `view` boundaries.
     - However, for the `KeyboardViewController`, it did not when the `UISplitViewController` primary column was shown.
     - However however, the `DrawableMarkdownViewController` did get updated bounds!
     
     So, we want to request an extra layout pass _only_ when the primary column has just been shown and we think this bug is about to occur.
     If we do it all the time, scrolling and other features don't work!
     
     Toggle this var on when primary column is hidden, and off after the extra layout pass is completed.
     */
    var needLayoutKeyboard = false
    
    init(){}
}
