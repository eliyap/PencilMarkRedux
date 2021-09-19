//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 19/9/21.
//

import Foundation

extension NSRange {
    func offset(by offset: Int) -> NSRange {
        NSMakeRange(offset + lowerBound, length)
    }
}
