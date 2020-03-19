//
//  File.swift
//  
//
//  Created by Boris Gutic on 19.03.20.
//

import Foundation

public extension Collection {
    subscript(safe i: Index) -> Element? {
        indices.contains(i) ? self[i] : nil
    }
}
