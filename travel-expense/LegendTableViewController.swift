//
// LegendTableViewController.swift
// travel-expense
//
// Created by Mileage Tracker Team on 12/4/14.
// Authors:
// Abi Kasraie
// Julian Gigola
// Michael Layman
// Saan Saeteurn
//
// Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//


import UIKit

class LegendTableViewController: UITableViewController {

    private var dataSource_:CoreDataSource! = CoreDataSource()
    
    @IBOutlet var legend:UITableView!
    
    var delegate:UITableViewDelegate!
    
    func setDataSource(dataSource:CoreDataSource!) {
        self.dataSource_ = dataSource
    }
    
    func reloadData() {
        self.legend.reloadData()
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
        cell.subTitle.text = (dataSource_.get("tripDate", index: indexPath.row) as NSDate)
                .dateToString("MM-dd-yyyy")
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
