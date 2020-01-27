//
//  String+Extensions.swift
//  BusinessLogic
//
//  Created by Boris Gutic on 15.01.20.
//  Copyright © 2020 Boris Gutic. All rights reserved.
//

import Foundation

extension String {
    func matching(regularExpression re: String) -> [String] {
        if let regex = try? NSRegularExpression(pattern: re, options: []) {
            let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        }
        return []
    }
}
