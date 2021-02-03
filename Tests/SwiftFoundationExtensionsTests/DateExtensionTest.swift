//
//  DateExtensionTest.swift
//  
//
//  Created by Boris Gutic on 23.03.20.
//

import Foundation
import XCTest
import SwiftFoundationExtensions

class DateExtensionTest: XCTestCase {
    
    private var calendar: Calendar!
    
    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
    }
    
    override func tearDown() {
        calendar = nil
        super.tearDown()
    }
    
    func test_day_shouldReturnOne() {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        XCTAssertEqual(date.dayInMonth(calendar), 1)
    }
    
    func test_minuesInDay_shouldBe66() {
        let offset = Calendar.current.timeZone.secondsFromGMT() / 60
        let date = Date(timeIntervalSinceReferenceDate: 60 * 60 + 6*60)
        XCTAssertEqual(date.minutesInDay(calendar) - offset, 66)
    }
    
    func test_adjustedWeekdayIndex_shouldBeOne() {
        let date = Date(timeIntervalSinceReferenceDate: 0) // 01.01.2001, Monday
        XCTAssertEqual(date.adjustedWeekdayIndex(calendar), 1)
    }
    
    func test_adjustedWeekdayIndex_shouldBeZeroWithFirstWeekdayBeingTwo() {
        calendar.firstWeekday = 2
        let date = Date(timeIntervalSinceReferenceDate: 0) // 01.01.2001, Monday
        XCTAssertEqual(date.adjustedWeekdayIndex(calendar), 0)
    }
    
    func test_dayOfWeek_shouldBeTwo() {
        let date = Date(timeIntervalSinceReferenceDate: 0) // 01.01.2001, Monday
        XCTAssertEqual(date.dayOfWeek(calendar), 2)
    }
    
    func test_adjustedWeekdayIndex_shouldBeThree() {
        let date = Date(timeIntervalSinceReferenceDate: 60*60*25) // 02.01.2001, Tuesday
        XCTAssertEqual(date.adjustedWeekdayIndex(calendar), 2)
    }
    
    func test_adjustedWeekdayIndex_shouldBeOneWithFirstWeekdayBeingTwo() {
        calendar.firstWeekday = 2
        let date = Date(timeIntervalSinceReferenceDate: 60*60*25) // 02.01.2001, Tuesday
        XCTAssertEqual(date.adjustedWeekdayIndex(calendar), 1)
    }
    
    func test_dayOfWeek_shouldBeThree() {
        let date = Date(timeIntervalSinceReferenceDate: 60*60*25) // 02.01.2001, Tuesday
        XCTAssertEqual(date.dayOfWeek(calendar), 3)
    }
    
    func test_nextDay_shoulBe20010102() {
        let date = Date(timeIntervalSinceReferenceDate: 0).nextDay(calendar)
        XCTAssertEqual(date, Date(timeIntervalSinceReferenceDate: 60*60*24))
    }
    
    func test_nextDay_shoulBe20001231() {
        let date = Date(timeIntervalSinceReferenceDate: 0).previousDay(calendar)
        XCTAssertEqual(date, Date(timeIntervalSinceReferenceDate: -60*60*24))
    }
    
    func test_nextWeek_shouldBe20010108() {
        let date = Date(timeIntervalSinceReferenceDate: 0).nextWeek(calendar)
        XCTAssertEqual(date, Date(timeIntervalSinceReferenceDate: 60*60*24*7))
    }
    
    func test_previousWeek_shouldBe20001225() {
        let date = Date(timeIntervalSinceReferenceDate: 0).previousWeek(calendar)
        XCTAssertEqual(date, Date(timeIntervalSinceReferenceDate: -60*60*24*7))
    }
    
    func test_previousMonth_shouldBe20001201() {
        let offset = TimeInterval(Calendar.current.timeZone.secondsFromGMT())
        let month = Date(timeIntervalSinceReferenceDate: 0).previousMonth(calendar)
        XCTAssertEqual(month.lowerBound, Date(timeIntervalSinceReferenceDate: -60*60*24*31 - offset))
        XCTAssertEqual(month.upperBound, Date(timeIntervalSinceReferenceDate: -offset))
    }
    
    func test_sameDay_shouldBeTrue() {
        XCTAssertTrue(
            Date(timeIntervalSinceReferenceDate: 0)
                .sameDay(as: Date(timeIntervalSinceReferenceDate: 60), calendar: calendar)
        )
    }
    
    func test_sameDay_shouldBeFalse() {
        XCTAssertFalse(
            Date(timeIntervalSinceReferenceDate: 0)
                .sameDay(as: Date(timeIntervalSinceReferenceDate: 60*60*25), calendar: calendar)
        )
    }
    
    func test_range_containsDateShouldContainDate() {
        let date = Date(timeIntervalSinceReferenceDate: 60*60*25) // 02.01.2001, Tuesday
        let range = date.weekRange()
        XCTAssertTrue(range.contains(date))
        XCTAssertTrue(range.contains(date.weekRange().lowerBound))
        XCTAssertFalse(range.contains(date.weekRange().upperBound))
    }
    
    func test_range_containsDateShouldNotContainDate() {
        let date = Date(timeIntervalSinceReferenceDate: 60*60*25) // 02.01.2001, Tuesday
        let range = date.weekRange()
        XCTAssertFalse(range.contains(date.adding(weeks: 1)))
    }
    
    // MARK: - Helper
    
    private func printDate(_ date: Date) {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .full
        print("🗓 date = " + f.string(from: date))
    }
}
