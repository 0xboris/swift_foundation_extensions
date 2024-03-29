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
    
    func test_minuesInDay_shouldBe166() {
        let date = Date(timeIntervalSinceReferenceDate: 60 * 60 + 6*60)
        XCTAssertEqual(date.minutesInDay(calendar), 126)
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
        let month = Date(timeIntervalSinceReferenceDate: 0).previousMonth(calendar)
        XCTAssertEqual(month.lowerBound, Date(with: "01.12.2000", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(month.upperBound, Date(with: "01.01.2001", calendar: calendar)?.startOfDay(calendar))
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
        let range = date.weekRange(calendar)
        XCTAssertTrue(range.contains(date))
        XCTAssertTrue(range.contains(date.weekRange(calendar).lowerBound))
        XCTAssertFalse(range.contains(date.weekRange(calendar).upperBound))
    }
    
    func test_range_containsDateShouldNotContainDate() {
        let date = Date(timeIntervalSinceReferenceDate: 60*60*25) // 02.01.2001, Tuesday
        let range = date.weekRange(calendar)
        XCTAssertFalse(range.contains(date.adding(weeks: 1, calendar: calendar)))
    }
    
    func test_range_weeksShouldReturnCorrectRangesForAllWeeksForJauary2001() {
        let calendar = Calendar.current
        let date = Date(timeIntervalSinceReferenceDate: 0)
        let weeks = date.monthRange(calendar).weeks(calendar)
        XCTAssertEqual(weeks.count, 5)
        XCTAssertEqual(weeks.first?.lowerBound, date.startOfDay(calendar))
        XCTAssertEqual(weeks.first?.upperBound, Date(with: "08.01.2001", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(weeks[1].lowerBound, Date(with: "08.01.2001", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(weeks[1].upperBound, Date(with: "15.01.2001", calendar: calendar)?.startOfDay(calendar))
    }
    
    func test_range_weeksShouldReturnCorrectRangesForAllWeeksForFebruary2001() {
        let calendar = Calendar.current
        let date = Date(with: "01.02.2001", calendar: calendar)!.startOfDay(calendar)
        let weeks = date.monthRange(calendar).weeks(calendar)
        XCTAssertEqual(weeks.count, 5)
        XCTAssertEqual(weeks.first?.lowerBound, Date(with: "29.01.2001", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(weeks.first?.upperBound, Date(with: "05.02.2001", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(weeks[1].lowerBound, Date(with: "05.02.2001", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(weeks[1].upperBound, Date(with: "12.02.2001", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(weeks[2].lowerBound, Date(with: "12.02.2001", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(weeks[2].upperBound, Date(with: "19.02.2001", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(weeks[3].lowerBound, Date(with: "19.02.2001", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(weeks[3].upperBound, Date(with: "26.02.2001", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(weeks[4].lowerBound, Date(with: "26.02.2001", calendar: calendar)?.startOfDay(calendar))
        XCTAssertEqual(weeks[4].upperBound, Date(with: "05.03.2001", calendar: calendar)?.startOfDay(calendar))
    }
    
    // MARK: - Helper
    
    private func printDate(_ date: Date) {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .full
        print("🗓 date = " + f.string(from: date))
    }
}
