//
//  TripDataModel.swift
//  travel-expense
//
//  Created by Saan Saeteurn on 11/24/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import UIKit
import CoreData

class TripDataModel: NSObject {
   
    func getManageObjectContext() -> NSManagedObjectContext {
        // Get an NSManagedObjectContext from our application delegate.
        
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        
        var error : NSError? = nil
        if !context.save(&error) {
            println("Error, failed to obtain an NSManagedObjectContext...aborting.")
            abort()
        }
        
        return context
    }
    
    func getNewTripObject() -> Trip {
        // Get a new Trip object to be saved into Core Data.
        
        let context = getManageObjectContext()
        let newEnt = NSEntityDescription.entityForName("Trip", inManagedObjectContext: context)
        var newTripObject = Trip(entity: newEnt!, insertIntoManagedObjectContext: context)
        
        var error : NSError? = nil
        if !context.save(&error) {
            println("Error, failed to instantiate a new Trip object...aborting")
            abort()
        }
        
        return newTripObject
    }
    
    func getFetchRequest() -> NSFetchRequest {
        // Get an NSFetchRequest object from our data model Trip.
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        return fetchRequest
    }
}
