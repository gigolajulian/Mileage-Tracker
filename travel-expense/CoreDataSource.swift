//
//  CoreDataSource.swift
//  Mileage Tracker
//
//  Created by cisstudents on 12/4/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import CoreData

class CoreDataSource: NSObject {
    
    private let coreData: TripDataModel = TripDataModel()
    private var data_:[AnyObject] = []
    private var predicate_:NSPredicate? = nil
    
    func get(field:NSString, index:Int) -> AnyObject! {
        return (data_[index] as NSManagedObject).valueForKey(field)
    }
    
    func setPredicate(predicate:NSPredicate?) -> CoreDataSource {
        self.predicate_ = predicate
        return self
    }
    
    func count() -> Int {
        return data_.count
    }
    
    func reload() -> CoreDataSource {
        
        let context = coreData.getManageObjectContext()
        let fetchRequest = coreData.getFetchRequest()
        
        if (predicate_ != nil) {
            fetchRequest.predicate = self.predicate_
        }
        
        var error:NSError?
        let result:[AnyObject]! = context
            .executeFetchRequest(fetchRequest, error: &error)
        
        // CRAP: This is bloat and redundant
        if (error == nil) {
            if (result != nil) {
                data_.removeAll(keepCapacity: true)
                data_.extend(result)
            }
        } else {
            println(error)
        }
        
        return self
    }
    
    func dispose() {
        data_.removeAll(keepCapacity: false)
        predicate_ = nil
    }
}