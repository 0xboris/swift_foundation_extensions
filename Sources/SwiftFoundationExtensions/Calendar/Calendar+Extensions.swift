//
//  Calendar+Extensions.swift
//  
//
//  Created by Boris Gutic on 17.09.20.
//

import Foundation

public extension Calendar {
    static var localized: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale.autoupdatingCurrent
        return cal
    }
    
    var adjustedWeekDayIndices: [Int] {
        var indices = Array(stride(from: firstWeekday - 1, to: 7, by: 1))
        if indices.count != 7 {
            indices.append(contentsOf: Array(stride(from: 0, to: 7 - indices.count, by: 1)))
        }
        return indices
    }
}
