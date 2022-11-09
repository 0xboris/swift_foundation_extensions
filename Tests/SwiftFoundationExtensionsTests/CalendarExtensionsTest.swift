//
//  CalendarExtensionsTest.swift
//  
//
//  Created by Boris Gutic on 09.11.22.
//

import XCTest

final class CalendarExtensionsTest: XCTestCase {
    func testAdjustedWeekDayIndicesWithFirstDaySunday() {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 1
        XCTAssertEqual(cal.adjustedWeekDayIndices, [0 ,1, 2, 3, 4, 5, 6])
    }
    
    func testAdjustedWeekDayIndicesWithFirstDayMonday() {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2
        XCTAssertEqual(cal.adjustedWeekDayIndices, [1, 2, 3, 4, 5, 6, 0])
    }
    
    func testAdjustedWeekDayIndicesWithFirstDayTuesday() {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 3
        XCTAssertEqual(cal.adjustedWeekDayIndices, [2, 3, 4, 5, 6, 0, 1])
    }
    
    func testAdjustedWeekDayIndicesWithFirstDayWednesday() {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 4
        XCTAssertEqual(cal.adjustedWeekDayIndices, [3, 4, 5, 6, 0, 1, 2])
    }
    
    func testAdjustedWeekDayIndicesWithFirstDayThursday() {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 5
        XCTAssertEqual(cal.adjustedWeekDayIndices, [4, 5, 6, 0, 1, 2, 3])
    }
    
    func testAdjustedWeekDayIndicesWithFirstDayFriday() {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 6
        XCTAssertEqual(cal.adjustedWeekDayIndices, [5, 6, 0, 1, 2, 3, 4])
    }
    
    func testAdjustedWeekDayIndicesWithFirstDaySaturday() {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 7
        XCTAssertEqual(cal.adjustedWeekDayIndices, [6, 0, 1, 2, 3, 4, 5])
    }
}
