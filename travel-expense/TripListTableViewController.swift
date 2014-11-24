//
//  TripListTableViewController.swift
//  travel-expense
//
//  Created by Saan Saeteurn on 11/23/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import UIKit

class TripListTableViewController: UITableViewController {
    
    let coreData: TripDataModel = TripDataModel()
    
    var tripList : Array<AnyObject> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(animated: Bool) {
        
        let context = coreData.getManageObjectContext()
        let fetchRequest = coreData.getFetchRequest()
        tripList = context.executeFetchRequest(fetchRequest, error: nil)!
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier? == "update" {
            var selectedTripObject: Trip = tripList[self.tableView.indexPathForSelectedRow()!.row] as Trip
            
            let tripViewController = segue.destinationViewController as TripViewController
            
            tripViewController.trip = selectedTripObject.trip
            tripViewController.origin = selectedTripObject.origin
            tripViewController.destination = selectedTripObject.destination
            tripViewController.departureDate = selectedTripObject.departureDate
            tripViewController.arrivalDate = selectedTripObject.arrivalDate
            tripViewController.totalDistance = selectedTripObject.totalDistance
            tripViewController.totalCost = selectedTripObject.totalCost
            tripViewController.tripDescription = selectedTripObject.tripDescription
            tripViewController.existingTripObject = selectedTripObject
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return tripList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell {
        // Configure the cell...
        
        let cellIdentifier : NSString = "tripCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath!) as UITableViewCell

        if let indexPathUnwrapped = indexPath? {
            var tripObject : Trip = tripList[indexPathUnwrapped.row] as Trip
            cell.textLabel.text = tripObject.trip
            cell.detailTextLabel?.text = tripObject.departureDate + " - " + tripObject.tripDescription
        }

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let context = coreData.getManageObjectContext()
        
        if editingStyle == .Delete {
            if let tableViewUnwrapped = self.tableView {
                context.deleteObject(tripList[indexPath.row] as Trip)
                tripList.removeAtIndex(indexPath.row)
                tableViewUnwrapped.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            var error : NSError? = nil
            if !context.save(&error) {
                abort()
            }
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
