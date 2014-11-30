//
//  Trip.swift
//  travel-expense
//
//  Created by Mileage Tracker Team on 11/23/14.
//  Authors:
//          Abi Kasraie
//          Julian Gigola
//          Michael Layman
//          Saan Saeteurn
//
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import Foundation
import CoreData

@objc(Trip)
class Trip: NSManagedObject {

    @NSManaged var trip: String
    @NSManaged var origin: String
    @NSManaged var destination: String
    @NSManaged var departureDate: NSDate
    @NSManaged var arrivalDate: NSDate
    @NSManaged var totalDistance: Float
    @NSManaged var totalCost: Float
    @NSManaged var tripDescription: String
    
    // Following for dev purposes only
    @NSManaged var zDev_totalCost: Float
    @NSManaged var zDev_arrivalDate: NSDate
    
    override func awakeFromInsert() {
        // default values
        self.trip = ""
        self.origin = ""
        self.destination = ""
        self.departureDate = NSDate()
        self.arrivalDate = NSDate()
        self.totalDistance = 0.00
        self.totalCost = 0.00
        self.tripDescription = ""
        self.zDev_totalCost = 0.00
        self.zDev_arrivalDate = NSDate()
    }
}
