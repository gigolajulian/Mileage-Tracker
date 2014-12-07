//
//  TripListTableViewController.swift
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

import UIKit

class TripListTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    let coreData: TripDataModel = TripDataModel()
    var tripList : Array<Trip> = []
    var filteredTripList: Array<Trip> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(animated: Bool) {
        
        let context = coreData.getManageObjectContext()
        let fetchRequest = coreData.getFetchRequest()
        
        let results = context.executeFetchRequest(fetchRequest, error: nil)
        
        if let castedResults = results as? [Trip] {
            println(self.searchDisplayController)
            if (self.searchDisplayController!.active)
            {
               filteredTripList = castedResults
            }
            else
            {
               tripList = castedResults
            }
            
        }
    
        tableView.reloadData()
    }
    
    // Function to convert the input text to all Caps
    func capsVersion (origString : String) -> String {
        var capsInput = String()
        for c in origString {
            capsInput = capsInput + String(c).uppercaseString
        }
        return capsInput
    }
    
    // Filter the Array if Search Text exists in Trip Name
    func filterContentForSearchText(searchText: String) {
        self.filteredTripList = self.tripList.filter({(tripObject: Trip)  -> Bool in
            var baseStr = self.capsVersion(tripObject.trip)
            var searchStr = self.capsVersion(searchText)
            let stringMatch = baseStr.rangeOfString(searchStr)
            return stringMatch != nil   })
    }

    //     These two methods are part of the
    //     UISearchDisplayControllerDelegate protocol:
    // Method 1
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    // Method 2
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "update" {
            //var selectedTripObject: Trip = tripList[self.tableView.indexPathForSelectedRow()!.row] as Trip
            //let tripViewController = segue.destinationViewController as TripViewController
            
            var selectedTripObject: Trip
            
            // Check if the segue is from a normal table view
            // or a Search-filtered view
            if (self.searchDisplayController!.active) {
                let tableView = self.searchDisplayController!.searchResultsTableView
                let indexPath = tableView.indexPathForSelectedRow()
                selectedTripObject = filteredTripList[indexPath!.row] as Trip
            
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()
                selectedTripObject = tripList[indexPath!.row] as Trip
            }
            
            let tripViewController = segue.destinationViewController as TripViewController
            
            tripViewController.trip = selectedTripObject.trip
            tripViewController.origin = selectedTripObject.origin
            tripViewController.destination = selectedTripObject.destination
            //tripViewController.tripDate = selectedTripObject.tripDate
            tripViewController.totalDistance = selectedTripObject.totalDistance
            tripViewController.totalCost = selectedTripObject.totalCost
            tripViewController.tripDescription = selectedTripObject.tripDescription
            tripViewController.existingTripObject = selectedTripObject
        }
        
        if segue.identifier == "newTrip" {
            println("DEBUG: New Trip")
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
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return filteredTripList.count
        } else {
            return tripList.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell {
        // Configure the cell...
        var tripObject : Trip
        let cellIdentifier : NSString = "tripCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath!) as UITableViewCell
      
        let row = indexPath?.row
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            tripObject = filteredTripList[row!]  }
        else {  tripObject = tripList[row!]  }

        // Configure the cell
        //if (cell == nil) {
        //    cell = CustomTableCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)   }
   
        cell.textLabel?.text = tripObject.trip
        var tripDateString: NSString = coreData.dateFormatter.stringFromDate(tripObject.tripDate)
        cell.detailTextLabel?.text = tripDateString + " - " + tripObject.tripDescription
        
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
