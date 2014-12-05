//
//  DatePickerDelegate.swift
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

@objc
protocol DatePickerDelegate {
    
    /*
    Date range seletion event.
    
    @param (NSDate?) beginDate
    @param (NSDate?) endDate
    */
    optional func datesSelected(beginDate:NSDate?, endDate:NSDate?)
    
    /*
    Cancel event.
    */
    optional func cancel()
}