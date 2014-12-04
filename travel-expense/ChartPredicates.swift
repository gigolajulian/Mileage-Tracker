//
//  ChartPredicates.swift
//  travel-expense
//
//  Created by cisstudents on 12/2/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import Foundation

struct ChartPredicates {
    
    static private func createDate_(
        calendarIdentifier:String = NSGregorianCalendar,
        second:Int, minute:Int, hour:Int,
        day:Int, month:Int, year:Int) -> NSDate
    {
        
        let caln:NSCalendar! = NSCalendar(calendarIdentifier: calendarIdentifier)
        
        let comp:NSDateComponents = NSDateComponents()
        comp.year = year
        comp.month = month
        comp.day = day
        comp.hour = hour
        comp.minute = minute
        comp.second = second
        
        return caln.dateFromComponents(comp)!
    }
    
    static private func dateByAdding_(
        calendar: String = NSGregorianCalendar,
        second: Int = 0, minute: Int = 0, hour: Int = 0,
        day:Int, month:Int, year:Int,
        toDate:NSDate) -> NSDate
    {
        
        // define calendar
        let caln:NSCalendar! = NSCalendar(calendarIdentifier: calendar)
        
        // decompose into components
        let comp:NSDateComponents! = caln.components(
            NSCalendarUnit.CalendarUnitYear |
            NSCalendarUnit.MonthCalendarUnit |
            NSCalendarUnit.DayCalendarUnit |
            NSCalendarUnit.HourCalendarUnit |
            NSCalendarUnit.MinuteCalendarUnit |
            NSCalendarUnit.SecondCalendarUnit,
            fromDate: toDate)
        
        // apply range
        comp.day = day
        comp.month = month
        comp.year = year
        comp.hour = hour
        comp.minute = minute
        comp.second = second
        
        // calc
        return caln.dateByAddingComponents(comp, toDate: toDate, options: NSCalendarOptions.allZeros)!
    }
    
    
    
    
    static private func buildDateRangePredicate_(
        start:NSDate, end:NSDate) -> NSPredicate
    {
        let subPredicates:[NSPredicate!]! = [
            NSPredicate(format: "(tripDate >= %@)",start),
            NSPredicate(format: "(tripDate < %@)",end)]
        
        return NSCompoundPredicate(
            type: NSCompoundPredicateType.AndPredicateType,
            subpredicates: subPredicates)
    }
    
    static func monthly(month:Int, year:Int) -> NSPredicate {
        
        let start = createDate_(
            second: 0, minute: 0, hour: 0,
            day: 1, month: month, year: year)
        let end = dateByAdding_(
            day: 0, month: 1, year: 0,
            toDate: start)

        return buildDateRangePredicate_(start, end:end)
    }
    
    static func yearly(year:Int = 2014) -> NSPredicate {
    
        let start = createDate_(
            second: 0, minute: 0, hour: 0,
            day: 1, month: 1, year: year)
        let end = dateByAdding_(
            day: 0, month: 0, year: 1,
            toDate: start)
        
        return buildDateRangePredicate_(start, end: end)
    }
    
    static func customDateRange(
        start:NSDate, end:NSDate) -> NSPredicate
    {
        return buildDateRangePredicate_(start, end: end)
    }
}

extension NSDate {
    func printComponents() {
        
        let caln:NSCalendar! = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        // decompose into components
        let comp:NSDateComponents! = caln.components(
            NSCalendarUnit.CalendarUnitYear |
            NSCalendarUnit.MonthCalendarUnit |
            NSCalendarUnit.DayCalendarUnit |
            NSCalendarUnit.HourCalendarUnit |
            NSCalendarUnit.MinuteCalendarUnit |
            NSCalendarUnit.SecondCalendarUnit,
            fromDate: self)
        
        println("****")
        println("date: \(comp.month)-\(comp.day)-\(comp.year)")
        println("time: \(comp.hour):\(comp.minute):\(comp.second)")
    }
}