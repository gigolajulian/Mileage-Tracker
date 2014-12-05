//
//  LegendTableViewController.swift
//  travel-expense
//
//  Created by cisstudents on 12/4/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import UIKit

class LegendTableViewController: UITableViewController {

    private var dataSource_:CoreDataSource!
    
    @IBOutlet var legend:UITableView!
    
    var delegate:UITableViewDelegate!
    
    func setDataSource(dataSource:CoreDataSource!) {
        self.dataSource_ = dataSource
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        legend.delegate = self.delegate
        legend.layer.borderWidth = 1.0
        legend.layer.cornerRadius = 4.0
        legend.layer.borderColor = UIColor.grayColor().CGColor
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        legend.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
//        println("refresh: \(dataSource_.count())")
        return dataSource_.count()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:LegendTableViewCell = tableView
            .dequeueReusableCellWithIdentifier(
                "reuseIdentifier",
                forIndexPath: indexPath) as LegendTableViewCell
        
        let color:UIColor = CPTPieChart
            .defaultPieSliceColorForIndex(UInt(indexPath.row)).uiColor
        cell.leftBorder.backgroundColor = color
        cell.title.text = dataSource_.get(
            "trip",
            index: indexPath.row) as NSString
        cell.subTitle.text = "CATS"
        //coreData_.dateFormatter
        //    .stringFromDate(
        //        dataSource_.get("tripDate", index: indexPath.row) as NSDate)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
