//
//  NSDate_Ext.swift
//  travel-expense
//
// Created by ML on 12/5/14.
// Authors:
// Abi Kasraie
// Julian Gigola
// Michael Layman
// Saan Saeteurn
//
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import Foundation

extension NSDate {
    
    /*
    Converts a date to a provided format.
    
    @param (NSString!) Date format, i.e.: MM-dd-yyyy
    @returns Returns a string in the provided format
    */
    func dateToString(format:NSString!) -> NSString {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}

extension String {
    
    /*
    Converts a string date into its NSDate equivalent.
    
    @param (NSString!) Date format, i.e.: MM-dd-yyyy
    @returns Returns a NSDate with the provided format
    */
    func stringToDate(format:NSString!) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.dateFromString(self)
    }
}