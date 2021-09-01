//
//  Date+Extensionts.swift
//  TimeKeeper
//
//  Created by Boris Gutic on 17/01/2017.
//  Copyright © 2017 Boris Gutic. All rights reserved.
//

import Foundation

public typealias Minutes = Int
public typealias Hours = Double

public extension Hours {
    init(from: Date, to: Date) {
        self = to.timeIntervalSince(from) / (60 * 60)
    }

    init(minutes: Minutes) {
        self = Double(minutes) / 60
    }

    var minutes: Minutes {
        return Minutes(self * 60)
    }
}

public extension Minutes {
    init(from: Date, to: Date) {
        self = Int(to.timeIntervalSince(from) / 60.0)
    }
}

public extension Date {
    
    /// Returns the day in the month (e.g. 13 for 13th February)
    func dayInMonth(_ calendar: Calendar) -> Int {
        return calendar.component(.day, from: self)
    }

    func minutesInDay(_ calendar: Calendar) -> Minutes {
        return calendar.component(.hour, from: self) * 60 +
        calendar.component(.minute, from: self)
    }
    
    func dayOfWeek(_ calendar: Calendar) -> Int {
        calendar.component(.weekday, from: self)
    }
    
    /// Returns the index of the day, adjusted to the first day of week. so
    /// - Example: If first day of week is 2 (Monday), this would return 0.
    func adjustedWeekdayIndex(_ calendar: Calendar) -> Int {
        (calendar.component(.weekday, from: self) + (7 - calendar.firstWeekday)) % 7
    }
    
    func nextDay(_ calendar: Calendar) -> Date {
        return adding(days: 1, calendar: calendar)
    }
    
    func previousDay(_ calendar: Calendar) -> Date {
        return adding(days: -1, calendar: calendar)
    }
    
    func nextWeek(_ calendar: Calendar) -> Date {
        return adding(days: 7, calendar: calendar)
    }
    
    func previousWeek(_ calendar: Calendar) -> Date {
        return adding(days: -7, calendar: calendar)
    }

    func previousMonth(_ calendar: Calendar) -> Range<Date> {
        let start = monthRange(calendar).lowerBound
        let midPreviousMonth = start.adding(days: -15, calendar: calendar)
        return midPreviousMonth.monthRange(calendar)
    }
    
    func sameDay(as date: Date, calendar: Calendar) -> Bool {
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    func sameWeek(as date: Date, calendar: Calendar) -> Bool {
        return weekRange(calendar).contains(date)
    }
    
    func sameMonth(as date: Date, calendar: Calendar) -> Bool {
        monthRange(calendar).contains(date)
    }
    
    func isLater(than date: Date) -> Bool {
        return self.timeIntervalSince(date) > 0
    }
    
    func startOfDay(_ calendar: Calendar) -> Date {
        return calendar.startOfDay(for: self)
    }
    
    func endOfDay(_ calendar: Calendar) -> Date {
        self.adding(days: 1, calendar: calendar).startOfDay(calendar).addingTimeInterval(-1)
    }
    
    func noon(_ calendar: Calendar) -> Date {
        return startOfDay(calendar).addingTimeInterval(60*60*12)
    }
    
    func days(between date: Date) -> Double {
        return date.timeIntervalSince(self) / (60*60*24)
    }
    
    func shortMonth(_ calendar: Calendar) -> String {
        let month = calendar.component(.month, from: self)
        return calendar.shortMonthSymbols[month-1]
    }
    
    func year(_ calendar: Calendar) -> Int {
        return calendar.component(.year, from: self)
    }
    
    func adding(days: Int, calendar: Calendar) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(days: Int, hours: Double, calendar: Calendar) -> Date {
        return adding(days: days, calendar: calendar).addingTimeInterval(hours * 60.0 * 60.0)
    }
    
    func adding(hours: Double) -> Date {
        return addingTimeInterval(hours * 60 * 60)
    }
    
    func adding(weeks: Int, calendar: Calendar) -> Date {
        return calendar.date(byAdding: .weekOfYear, value: weeks, to: self)!
    }
    
    func adding(months: Int, calendar: Calendar) -> Date {
        return calendar.date(byAdding: .month, value: months, to: self)!
    }
    
    func week(_ calendar: Calendar) -> Int {
        return calendar.component(.weekOfYear, from: self)
    }
    
    func range(_ calendar: Calendar) -> Range<Date> {
        startOfDay(calendar)..<endOfDay(calendar)
    }
    
    func weekRange(_ calendar: Calendar) -> Range<Date> {
        let week = calendar.dateInterval(of: .weekOfYear, for: self)!
        return week.start..<week.end
    }
    
    func monthRange(_ calendar: Calendar) -> Range<Date> {
        let month = calendar.dateInterval(of: .month, for: self)!
        return month.start..<month.end
    }

    func month(_ calendar: Calendar) -> Int {
        return calendar.component(.month, from: self)
    }

    func yearRange(_ calendar: Calendar) -> Range<Date> {
        let year = calendar.dateInterval(of: .year, for: self)!
        return year.start..<year.end
    }
    
    /// Returns the last seven days, including the date itself.
    func lastSevenDays(_ calendar: Calendar) -> [Date] {
        var week = [Date]()
        for i in -6...0 {
            week.append(self.adding(days: i, calendar: calendar).startOfDay(calendar))
        }
        return week
    }
    
    /// Returns the range of the last seven days, including the date itself.
    func lastSevenDaysRange(_ calendar: Calendar) -> Range<Date> {
        lastSevenDays(calendar).range!
    }
    
    mutating func moveTo(date: Date, calendar: Calendar) {
        self = movingTo(date: date, calendar: calendar)
    }
    
    func movingTo(date: Date, calendar: Calendar) -> Date {
        var newDate = calendar.date(bySetting: .hour, value: calendar.component(.hour, from: self), of: date)!
        newDate = calendar.date(bySetting: .minute, value: calendar.component(.minute, from: self), of: newDate)!
        newDate = calendar.date(bySetting: .second, value: calendar.component(.second, from: self), of: newDate)!
        return newDate
    }
    
    static func dateComponentsFrom(_ string: String, calendar: Calendar) -> DateComponents {
        var year = calendar.component(.year, from: Date())
        var month = calendar.component(.month, from: Date())
        var day = calendar.component(.day, from: Date())
        
        let digits = string.matching(regularExpression: "[:punct:]*?[0-9]+[:punct:]*?")
        let letters = string.matching(regularExpression: "[:alpha:]+")
        
        for d in digits {
            let num = Int(d.matching(regularExpression: "[0-9]+").first!)!
            if num > 1970 {
                year = num
            } else if num > 0 && num <= 31 {
                if d.first == "." {
                    month = num
                } else {
                    day = num
                }
            }
        }
        
        for l in letters {
            for monthSymbol in calendar.monthSymbols {
                if monthSymbol.lowercased().contains(l.lowercased()) {
                    month = calendar.monthSymbols.firstIndex(of: monthSymbol)! + 1
                    continue
                }
            }
        }
        
        return DateComponents(calendar: nil,
                              timeZone: nil,
                              era: nil,
                              year: year,
                              month: month,
                              day: day,
                              hour: nil,
                              minute: nil,
                              second: nil,
                              nanosecond: nil,
                              weekday: nil,
                              weekdayOrdinal: nil,
                              quarter: nil,
                              weekOfMonth: nil,
                              weekOfYear: nil,
                              yearForWeekOfYear: nil)
    }
    
    init?(with string: String, calendar: Calendar) {
        if let date = calendar.nextDate(after: Date.distantPast,
                                   matching: Date.dateComponentsFrom(string, calendar: calendar),
                                   matchingPolicy: .nextTime) {
            self = date
        } else {
            return nil
        }
    }
}

public extension Range where Bound == Date {
    func dates(_ calendar: Calendar) -> [Date] {
        var dates = [lowerBound]
        var date = lowerBound.adding(days: 1, calendar: calendar)
        while date < upperBound {
            dates.append(date)
            date = date.adding(days: 1, calendar: calendar)
        }
        return dates
    }
    
    func weeks(_ calendar: Calendar) -> [Range<Date>] {
        var date = lowerBound
        var ranges = [Range<Date>]()
        while date < upperBound {
            ranges.append(date.weekRange())
            date = date.weekRange().lowerBound.adding(weeks: 1)
        }
        return ranges
    }
}

public extension RandomAccessCollection where Element == Date {
    var range: Range<Date>? {
        guard count > 1 else { return  nil}
        let dates = sorted(by: <)
        return dates[0]..<dates[count - 1]
    }
}
