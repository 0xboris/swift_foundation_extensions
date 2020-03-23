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
    
    func test_day_shouldReturnOne() {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        XCTAssertEqual(date.dayInMonth, 1)
    }
    
    func test_minuesInDay_shouldBe66() {
        let offset = Calendar.current.timeZone.secondsFromGMT() / 60
        let date = Date(timeIntervalSinceReferenceDate: 60 * 60 + 6*60)
        XCTAssertEqual(date.minutesInDay - offset, 66)
    }
    
    func test_dayOfWeek_shouldBeZero() {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        XCTAssertEqual(date.dayOfWeek, 0)
    }
    
    func test_dayOfWeek_shouldBeOne() {
        let date = Date(timeIntervalSinceReferenceDate: 60*60*25)
        XCTAssertEqual(date.dayOfWeek, 1)
    }
    
    func test_nextDay_shoulBe20010102() {
        let date = Date(timeIntervalSinceReferenceDate: 0).nextDay
        XCTAssertEqual(date, Date(timeIntervalSinceReferenceDate: 60*60*24))
    }
    
    func test_nextDay_shoulBe20001231() {
        let date = Date(timeIntervalSinceReferenceDate: 0).previousDay
        XCTAssertEqual(date, Date(timeIntervalSinceReferenceDate: -60*60*24))
    }
    
    func test_nextWeek_shouldBe20010108() {
        let date = Date(timeIntervalSinceReferenceDate: 0).nextWeek
        XCTAssertEqual(date, Date(timeIntervalSinceReferenceDate: 60*60*24*7))
    }
    
    func test_previousWeek_shouldBe20001225() {
        let date = Date(timeIntervalSinceReferenceDate: 0).previousWeek
        XCTAssertEqual(date, Date(timeIntervalSinceReferenceDate: -60*60*24*7))
    }
    
    func test_previousMonth_shouldBe20001201() {
        let offset = TimeInterval(Calendar.current.timeZone.secondsFromGMT())
        let month = Date(timeIntervalSinceReferenceDate: 0).previousMonth
        XCTAssertEqual(month.start, Date(timeIntervalSinceReferenceDate: -60*60*24*31 - offset))
        XCTAssertEqual(month.end, Date(timeIntervalSinceReferenceDate: -1 - offset))
    }
    
    func test_sameDay_shouldBeTrue() {
        XCTAssertTrue(
            Date(timeIntervalSinceReferenceDate: 0).sameDay(as: Date(timeIntervalSinceReferenceDate: 60))
        )
    }
    
    func test_sameDay_shouldBeFalse() {
        XCTAssertFalse(
            Date(timeIntervalSinceReferenceDate: 0).sameDay(as: Date(timeIntervalSinceReferenceDate: 60*60*25))
        )
    }
    
    
    
    // MARK: - Helper
    
    private func printDate(_ date: Date) {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .full
        print("🗓 date = " + f.string(from: date))
    }
}
