//
//  timeago.swift
//  hypebeast
//
//  Created by James Cheuk on 14/4/15.
//  Copyright (c) 2015 42Labs. All rights reserved.
//

import Foundation

func timeAgoSinceDate(_ date:Date, numericDates:Bool, showfullDateAfter24Hrs: Bool = true, showShortFormTime:Bool = true) -> String {
    
    let calendar = Calendar.current
    let unitFlags: NSCalendar.Unit = [NSCalendar.Unit.minute, NSCalendar.Unit.hour, NSCalendar.Unit.day, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.second]
    let now = Date()
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components(unitFlags, from: earliest, to: latest, options: [])
    
    if let year = components.year, year >= 2  {
        return showfullDateAfter24Hrs ? getDateString(date) : "\(year) years ago"
    } else if let year = components.year, year >= 1 {
        if (numericDates){
            return showfullDateAfter24Hrs ? getDateString(date) : "1 year ago"
        } else {
            return showfullDateAfter24Hrs ? getDateString(date) : "Last year"
        }
    } else if let month = components.month, month >= 2 {
        return showfullDateAfter24Hrs ? getDateString(date) : "\(month) months ago"
    } else if let month = components.month, month >= 1 {
        if (numericDates){
            return showfullDateAfter24Hrs ? getDateString(date) : "1 month ago"
        } else {
            return showfullDateAfter24Hrs ? getDateString(date) : "Last month"
        }
    } else if let weekOfYear = components.weekOfYear, weekOfYear >= 2 {
        return showfullDateAfter24Hrs ? getDateString(date) : "\(weekOfYear) weeks ago"
    } else if let weekOfYear = components.weekOfYear, weekOfYear >= 1 {
        if (numericDates){
            return showfullDateAfter24Hrs ? getDateString(date) : "1 week ago"
        } else {
            return showfullDateAfter24Hrs ? getDateString(date) : "Last week"
        }
    } else if let day = components.day, day >= 2 {
        return showfullDateAfter24Hrs ? getDateString(date) : "\(day) days ago"
    } else if let day = components.day, day >= 1 {
        if (numericDates){
            return showfullDateAfter24Hrs ? getDateString(date) : "1 day ago"
        } else {
            return showfullDateAfter24Hrs ? getDateString(date) : "Yesterday"
        }
    } else if let hour = components.hour, hour >= 2 {
        return showShortFormTime ? "\(hour) h" : "\(hour) hours ago"
    } else if let hour = components.hour, hour >= 1 {
        if (numericDates){
            return showShortFormTime ? "1 h" : "1 hour ago"
        } else {
            return showShortFormTime ? "1 h" : "An hour ago"
        }
    } else if let minute = components.minute, minute >= 2 {
        return showShortFormTime ? "\(minute) m" : "\(minute) minutes ago"
    } else if let minute = components.minute, minute >= 1 {
        if (numericDates){
            return showShortFormTime ? "1 m" : "1 minute ago"
        } else {
            return showShortFormTime ? "1 m" : "A minute ago"
        }
    } else if let second = components.second, second >= 3 {
        return showShortFormTime ? "\(second) s" : "\(second) seconds ago"
    } else {
        return "Just now"
    }
}

func getDateString(_ date:Date) -> String {
    //July 18, 2016
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    formatter.locale = Locale(identifier: "en-US")
    let dateString = formatter.string(from: date)
    return dateString
}
