//
//  Date.swift
//  CalendarLogic
//
//  Created by Lancy on 01/06/15.
//  Copyright (c) 2015 Lancy. All rights reserved.
//

import Foundation

public class Date: CustomStringConvertible, Equatable {
    
    public var day: Int
    public var month: Int
    public var year: Int
    
    public var isToday: Bool {
        let today = Date(date: NSDate())
        return (isEqual(today) == .OrderedSame)
    }
    
    public func isEqual(date: Date) -> NSComparisonResult {
        let selfComposite = (year * 10000) + (month * 100) + day
        let otherComposite = (date.year * 10000) + (date.month * 100) + date.day
        
        if selfComposite < otherComposite {
            return .OrderedAscending
        } else if selfComposite == otherComposite {
            return .OrderedSame
        } else {
            return .OrderedDescending
        }
    }
    
    public init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
    }
    
    public init(date: NSDate) {
        let part = date.monthDayAndYearComponents
        
        self.day = part.day
        self.month = part.month
        self.year = part.year
    }
    
    public var nsdate: NSDate {
        return NSDate.date(day, month: month, year: year)
    }
    
    public var description: String {
        return "\(day)-\(month)-\(year)"
    }
}

public func ==(lhs: Date, rhs: Date) -> Bool {
    return ((lhs.day == rhs.day) && (lhs.month == rhs.month) && (lhs.year == rhs.year))
}
