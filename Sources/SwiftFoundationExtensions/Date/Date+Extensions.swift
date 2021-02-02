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
    var dayInMonth: Int {
        return Calendar.current.component(.day, from: self)
    }

    var minutesInDay: Minutes {
        return Calendar.current.component(.hour, from: self) * 60 +
            Calendar.current.component(.minute, from: self)
    }
    
    var dayOfWeek: Int {
        let days = [0, 6, 0, 1, 2, 3, 4, 5]
        return days[Calendar.current.component(.weekday, from: self)]
    }
    
    var nextDay: Date {
        return adding(days: 1)
    }
    
    var previousDay: Date {
        return adding(days: -1)
    }
    
    var nextWeek: Date {
        return adding(days: 7)
    }
    
    var previousWeek: Date {
        return adding(days: -7)
    }

    var previousMonth: (start: Date, end: Date) {
        let start = monthSpan.start
        let midPreviousMonth = start.adding(days: -15)
        return midPreviousMonth.monthSpan
    }
    
    func sameDay(as date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func sameWeek(as date: Date) -> Bool {
        return weekRange.contains(date)
    }
    
    func sameMonth(as date: Date) -> Bool {
        monthRange.contains(date)
    }
    
    func isLater(than date: Date) -> Bool {
        return self.timeIntervalSince(date) > 0
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        self.adding(days: 1).startOfDay.addingTimeInterval(-1)
    }
    
    var noon: Date {
        return startOfDay.addingTimeInterval(60*60*12)
    }
    
    var midNightNextDay: Date {
        return startOfDay.addingTimeInterval(60*60*24)
    }
    
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    func days(between date: Date) -> Double {
        return date.timeIntervalSince(self) / (60*60*24)
    }
    
    private var shortAbbreviations: [String] {
        return [
            "Mo",
            "Tu",
            "We",
            "Th",
            "Fr",
            "Sa",
            "Su"
        ]
    }
    
    private var longAbbreviations: [String] {
        return [
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri",
            "Sat",
            "Sun"
        ]
    }
    
    var shortAbbreviation: String {
        return longAbbreviations[dayOfWeek]
    }

    var firstCharacterAbbreviation: String {
        let abrv = shortAbbreviations[dayOfWeek]
        return String(abrv[abrv.startIndex])
    }

    var shortMonth: String {
        let month = Calendar.current.component(.month, from: self)
        return Calendar.current.shortMonthSymbols[month-1]
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(days: Int, hours: Double) -> Date {
        return adding(days: days).addingTimeInterval(hours * 60.0 * 60.0)
    }
    
    func adding(hours: Double) -> Date {
        return addingTimeInterval(hours * 60 * 60)
    }
    
    func adding(weeks: Int) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self)!
    }
    
    func adding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    var week: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    var range: ClosedRange<Date> {
        startOfDay...endOfDay
    }
    
    var weekSpan: (start: Date, end: Date) {
        let start = adding(days: -dayOfWeek)
        let end = start.adding(days: 7)
        return (start.startOfDay, end.startOfDay)
    }
    
    var weekRange: ClosedRange<Date> {
        let week = Calendar.current.dateInterval(of: .weekOfYear, for: self)!
        return week.start...week.end.addingTimeInterval(-1)
    }
    
    var monthSpan: (start: Date, end: Date) {
        let month = Calendar.current.dateInterval(of: .month, for: self)!
        return (month.start, month.end.addingTimeInterval(-1))
    }
    
    var monthRange: ClosedRange<Date> {
        let month = Calendar.current.dateInterval(of: .month, for: self)!
        return month.start...month.end.addingTimeInterval(-1)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var yearSpan: (start: Date, end: Date) {
        let year = Calendar.current.dateInterval(of: .year, for: self)!
        return (year.start, year.end.addingTimeInterval(-1))
    }
    
    var weekDates: [Date] {
        let start = weekSpan.start
        var dates = [start]
        while dates.count < 7 {
            dates.append(start.adding(days: dates.count))
        }
        return dates
    }
    
    /// Returns the last seven days, including the date itself.
    var lastSevenDays: [Date] {
        var week = [Date]()
        for i in -6...0 {
            week.append(self.adding(days: i).startOfDay)
        }
        return week
    }
    
    /// Returns the range of the last seven days, including the date itself.
    var lastSevenDaysRange: Range<Date> {
        self.adding(days: -6).startOfDay..<self.adding(days: 1).startOfDay
    }
    
    mutating func moveTo(date: Date, using cal: Calendar = Calendar.current) {
        self = movingTo(date: date, using: cal)
    }
    
    func movingTo(date: Date, using cal: Calendar = Calendar.current) -> Date {
        var newDate = cal.date(bySetting: .hour, value: cal.component(.hour, from: self), of: date)!
        newDate = cal.date(bySetting: .minute, value: cal.component(.minute, from: self), of: newDate)!
        newDate = cal.date(bySetting: .second, value: cal.component(.second, from: self), of: newDate)!
        return newDate
    }
    
    static func dateComponentsFrom(_ string: String, cal: Calendar) -> DateComponents {
        var year = cal.component(.year, from: Date())
        var month = cal.component(.month, from: Date())
        var day = cal.component(.day, from: Date())
        
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
            for monthSymbol in cal.monthSymbols {
                if monthSymbol.lowercased().contains(l.lowercased()) {
                    month = cal.monthSymbols.firstIndex(of: monthSymbol)! + 1
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
    
    init?(with string: String, using cal: Calendar = Calendar.current) {
        if let date = cal.nextDate(after: Date.distantPast,
                                   matching: Date.dateComponentsFrom(string, cal: cal),
                                   matchingPolicy: .nextTime) {
            self = date
        } else {
            return nil
        }
    }
}

public extension ClosedRange where Bound == Date {
    var dates: [Date] {
        var dates = [lowerBound]
        var date = lowerBound.adding(days: 1)
        while date < upperBound {
            dates.append(date)
            date = date.adding(days: 1)
        }
        return dates
    }
}
