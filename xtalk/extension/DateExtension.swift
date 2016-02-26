//
//  DateExtension.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/2/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

extension NSDate {
    
    func dateFromString(date:String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.dateFromString(date)!
    }
    
    func stringFromDate() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(self)
    }
    
    //i.e  facebook created_time = 2015-06-18T19:00:53-07:00
    func dateFromISO8601(date:String) ->NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ" //iso 8601
        return dateFormatter.dateFromString(date)!
    }
    
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date)) years ago"   }//y
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date)) months ago"  }//M
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date)) weeks ago"   }//w
        if daysFrom(date)    > 0 { return "\(daysFrom(date)) days ago"    }//d
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date)) hours ago"   }//h
        if minutesFrom(date) > 0 { return "\(minutesFrom(date)) minutes ago" }//m
        if secondsFrom(date) > 0 { return "\(secondsFrom(date)) seconds ago" }//s
        return ""
    }
   
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> NSDate {
        let timezone: NSTimeZone = NSTimeZone.localTimeZone()
        let seconds: NSTimeInterval = NSTimeInterval(timezone.secondsFromGMTForDate(self))
        return NSDate(timeInterval: seconds, sinceDate: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> NSDate {
        let timezone: NSTimeZone = NSTimeZone.localTimeZone()
        let seconds: NSTimeInterval = -NSTimeInterval(timezone.secondsFromGMTForDate(self))
        return NSDate(timeInterval: seconds, sinceDate: self)
    }
}