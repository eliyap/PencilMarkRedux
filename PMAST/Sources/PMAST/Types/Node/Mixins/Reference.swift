//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 19/9/21.
//

import Foundation

protocol Reference: Association {
    var referenceType: ReferenceType { get }
}

enum ReferenceType: String {
    case shortcut
    case collapsed
    case full
}
