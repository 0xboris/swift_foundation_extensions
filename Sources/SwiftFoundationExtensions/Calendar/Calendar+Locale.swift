//
//  File.swift
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
}
