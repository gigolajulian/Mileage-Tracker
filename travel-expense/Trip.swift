//
//  Trip.swift
//  travel-expense
//
//  Created by Saan Saeteurn on 11/23/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import Foundation
import CoreData

@objc(Trip)
class Trip: NSManagedObject {

    @NSManaged var trip: String
    @NSManaged var origin: String
    @NSManaged var destination: String
    @NSManaged var departureDate: String
    @NSManaged var arrivalDate: String
    @NSManaged var totalDistance: String
    @NSManaged var totalCost: String
    @NSManaged var tripDescription: String
    
    // Following for dev purposes only
    @NSManaged var zDev_totalCost: Float
    @NSManaged var zDev_arrivalDate: NSDate
    
    override func awakeFromInsert() {
        // default values
        self.trip = ""
        self.origin = ""
        self.destination = ""
        self.departureDate = ""
        self.arrivalDate = ""
        self.totalDistance = ""
        self.totalCost = ""
        self.tripDescription = ""
        self.zDev_totalCost = 0
        self.zDev_arrivalDate = NSDate()
    }
}
