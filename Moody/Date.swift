//
//  Date.swift
//  Attendance Tracker
//
//  Created by Josh Smith on 8/13/22.
//

import Foundation

extension Date: RawRepresentable {
    
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
    
    var wholeDay: DateInterval {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let start = Calendar.current.date(from: components) ?? Date()
        components.day! += 1
        components.second! -= 1
        let end = Calendar.current.date(from: components) ?? Date()
        return DateInterval(start: start, end: end)
    }
    
    var monthStart: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var monthNumber: Int {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return components.month ?? 0
    }
    
    var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    var monthInterval: DateInterval {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let start = Calendar.current.date(from: components) ?? Date()
        components.month! += 1
        components.day! -= 1
        components.hour = 23
        components.minute = 59
        components.second = 59
        let end = Calendar.current.date(from: components) ?? Date()
        return DateInterval(start: start, end: end)
    }
    
    var monthRange: [Date] {
        
        var results = [Date]()
        
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.day = 1
        components.day! -= 1
        let start = Calendar.current.date(from: components) ?? Date()
                
        let days = Calendar.current.range(of: .day, in: .month, for: self)
        
        for day in days ?? 0..<1 {
            var newComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: start)
            newComponents.day! += day
            let newDate = Calendar.current.date(from: newComponents) ?? Date()
            results.append(newDate)
        }
        
        return results
        
    }
    
    var weekday: Date {
        var components = Calendar.current.dateComponents([.year, .month, .weekday, .day, .hour, .minute, .second], from: self)
        components.day = 1
        components.day! -= 1
        
        let eoMonth = Calendar.current.date(from: components) ?? Date()
        
        var eoMonthComponents = Calendar.current.dateComponents([.year, .month, .weekday, .day, .hour, .minute, .second], from: eoMonth)
        
        let weekday = eoMonthComponents.weekday!
        
        if weekday < 7 {
            eoMonthComponents.day! -= weekday
        }

        return Calendar.current.date(from: eoMonthComponents) ?? Date()
    }
    
    var extendedMonthRange: [DateInterval] {
        
        var results = [DateInterval]()
        
        var components = Calendar.current.dateComponents([.year, .month, .weekday, .day, .hour, .minute, .second], from: self)
        components.day = 1
        components.day! -= 1
        
        let eoMonth = Calendar.current.date(from: components) ?? Date()
        
        var eoMonthComponents = Calendar.current.dateComponents([.year, .month, .weekday, .day, .hour, .minute, .second], from: eoMonth)
        
        var weekday = eoMonthComponents.weekday!
        
        if weekday < 7 {
            eoMonthComponents.day! -= weekday
        } else {
            weekday = 0
        }

        let start = Calendar.current.date(from: eoMonthComponents) ?? Date()

        let days = Calendar.current.range(of: .day, in: .month, for: self)
        
        var lastDayComponents = Calendar.current.dateComponents([.year, .month, .weekday, .day, .hour, .minute, .second], from: self)
        lastDayComponents.month! += 1
        lastDayComponents.day = 1
        lastDayComponents.day! -= 1
        let lastWeekday = Calendar.current.date(from: lastDayComponents) ?? Date()
        
        let lastWeekdayComponents = Calendar.current.dateComponents([.year, .month, .weekday, .day, .hour, .minute, .second], from: lastWeekday)
        
        let extraDays = 6 - lastWeekdayComponents.weekday!
                
        let numberOfDays = (days?.last ?? 0) + weekday + extraDays
        
        for day in 0...numberOfDays {
            var newComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: start)
            newComponents.day! += day
            let newDate = Calendar.current.date(from: newComponents) ?? Date()
            results.append(newDate.wholeDay)
        }
        
        print("Comment (Extended Month Range): Days - \(days?.last ?? 0) + \(weekday) + \(extraDays), \(results.first!.start.formatted(date: .abbreviated, time: .omitted))–\(results.last!.end.formatted(date: .abbreviated, time: .omitted)).")
        
        return results
        
    }
    
    // Timeframes
    
    func year(from fiscalStart: Date) -> DateInterval {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fiscalStart)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let start = Calendar.current.date(from: components) ?? Date()
        components.year! += 1
        components.second! -= 1
        let end = Calendar.current.date(from: components) ?? Date()
        return DateInterval(start: start, end: end)
    }
    
    func quarters(from fiscalStart: Date) -> [DateInterval] {
        
        let q1 = addQuarter(from: fiscalStart)
        let q2 = addQuarter(from: q1.end.addingTimeInterval(1))
        let q3 = addQuarter(from: q2.end.addingTimeInterval(1))
        let q4 = addQuarter(from: q3.end.addingTimeInterval(1))
        
        print("Comment (quarters): Q1 \(q1.abbreviated)")
        print("Comment (quarters): Q2 \(q2.abbreviated)")
        print("Comment (quarters): Q3 \(q3.abbreviated)")
        print("Comment (quarters): Q4 \(q4.abbreviated)")
        return [q1, q2, q3, q4]
        
    }
    
    func priorYear(from fiscalStart: Date) -> DateInterval {
        
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: year(from: fiscalStart).start)
        components.second! -= 1
        let end = Calendar.current.date(from: components) ?? Date()
        
        components.year! -= 1
        components.day! += 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let start = Calendar.current.date(from: components) ?? Date()
        
        return DateInterval(start: start, end: end)
        
    }
    
    func quarter(from fiscalStart: Date) -> DateInterval? {
        return self.quarters(from: fiscalStart).first { quarter in
            quarter.contains(self)
        }
    }
    
    func addQuarter(from start: Date) -> DateInterval {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: start)
        components.day! += ((7*13) - 1)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let end = Calendar.current.date(from: components) ?? Date()
        return DateInterval(start: start, end: end)
    }
    
    func priorQuarter(from fiscalStart: Date) -> DateInterval? {
        let current = self.quarters(from: fiscalStart).firstIndex { quarter in
            quarter.contains(self)
        }
        if let current {
            if (1...4).contains(current)  {
                return self.quarters(from: fiscalStart)[current - 1]
            }
        }
        
        return nil
    }
    
    var month: DateInterval {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let start = Calendar.current.date(from: components) ?? Date()
        components.month! += 1
        components.second! -= 1
        let end = Calendar.current.date(from: components) ?? Date()
        return DateInterval(start: start, end: end)
    }
    
    var priorMonth: DateInterval {
        
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: month.start)
        components.second! -= 1
        let end = Calendar.current.date(from: components) ?? Date()
        
        components.month! -= 1
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let start = Calendar.current.date(from: components) ?? Date()
                
        return DateInterval(start: start, end: end)
        
    }
    
    var week: DateInterval {
        var components = Calendar.current.dateComponents([.year, .month, .weekday, .day, .hour, .minute, .second], from: self)
        components.day! -= (components.weekday! - 1)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let start = Calendar.current.date(from: components) ?? Date()
        components.day! += 7
        components.second! -= 1
        let end = Calendar.current.date(from: components) ?? Date()
        return DateInterval(start: start, end: end)
    }
    
    var priorWeek: DateInterval {
        
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: week.start)
        components.second! -= 1
        let end = Calendar.current.date(from: components) ?? Date()
        
        components.day! -= 7
        components.hour = 0
        components.minute = 0
        components.second = 0
        let start = Calendar.current.date(from: components) ?? Date()
        
        return DateInterval(start: start, end: end)
        
    }
    
}

extension DateInterval {
    
    var abbreviated: String {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)!
    }
    
}
