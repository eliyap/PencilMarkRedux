//
//  String.utf16Offset.swift
//  
//
//  Created by Secret Asian Man Dev on 7/9/21.
//

import Foundation

extension String {
    func utf16Offset(before idx: Int) -> Int {
        let strIdx = index(from: idx)
        let prevStrIdx: String.Index = index(before: strIdx)
        return prevStrIdx.utf16Offset(in: self)
    }
}
