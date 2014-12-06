//
//  PieChartViewController.swift
//  travel-expense
//
// Created by Mileage Tracker Team on 12/4/14.
// Authors:
// Abi Kasraie
// Julian Gigola
// Michael Layman
// Saan Saeteurn
//
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

/*
todo:

-DONE: legend (as seperate table?)
-stylings and chart labeling
-DONE: input date intervals
-DONE?: data for picked data
*/

import UIKit

class PieChartViewController:
UIViewController,
CPTPieChartDataSource,
UITableViewDelegate,
DatePickerDelegate
{
    
    private let coreData_:TripDataModel = TripDataModel()
    private let dataSource_:CoreDataSource = CoreDataSource()
    private let displaceHeight_:CGFloat = 50
    private var pieGraph : CPTXYGraph? = nil
    private var piePlot:CPTPieChart!
    private var constraint_:NSLayoutConstraint? = nil
    private var legendViewController_:LegendTableViewController? = nil
    private var changeDateMode_:Bool = false
    
    private var displayString_:NSString! = "Trips from: 1-1-2014 to: 12-31-2014"
 
    private let cancelImg_:UIImage = UIImage(named:"CANCEL.png")!
    //private let okImg_:UIImage = UIImage("OK.png")
    private let calendarImg_:UIImage = UIImage(named:"CALENDAR.png")!
    
    // CRAP: No likey global static
    private var idx:UInt = 100000
    private var reportTypes:[NSString] = ["totalDistance","totalCost"]
    
    @IBOutlet var hostingView:CPTGraphHostingView!
    @IBOutlet var statusBar:UILabel!
    @IBOutlet var report:UISegmentedControl!
    @IBOutlet var datePickerContainer:UIView!
    @IBOutlet var legendContainer:UIView!
    @IBOutlet var dateTextIndicator:UILabel!
    @IBOutlet var changeDateButton:UIButton!
    @IBOutlet var tertiaryStatusBar:UILabel!
    
    @IBAction func reportChange(sender: UISegmentedControl) {
        println(sender.selectedSegmentIndex)
        piePlot.reloadData()
        tertiaryStatusBar.text = "Total: \(totalValue_(reportTypes[report.selectedSegmentIndex]))"
        
    }
    
    @IBAction func changeDate(sender: UIButton) {
        
        self.changeDateMode_ = !self.changeDateMode_
        
        if (self.changeDateMode_) {
            displayString_ = dateTextIndicator.text!
            dateTextIndicator.text = "Select a date range"
            //changeDateButton.setTitle("Q", forState: .Normal)
            changeDateButton.setBackgroundImage(cancelImg_, forState: UIControlState.Normal)
        } else {
            dateTextIndicator.text = displayString_
            //changeDateButton.setTitle("CD", forState: .Normal)
            changeDateButton.setBackgroundImage(calendarImg_, forState: UIControlState.Normal)
        }
        
        toggleDatePicker_(self.changeDateMode_)
    }
    
    private func toggleDatePicker_(flag:Bool) {
        
        constraint_?.setValue(
            (flag) ? displaceHeight_ : 0,
            forKey: "constant")
        
        UIView.animateWithDuration(0.25,
            animations: {
                self.view.layoutIfNeeded()
            })
        
    }

    private func totalValue_(field:NSString) -> NSNumber {
        var num:CGFloat = 0.0
        for (var i:Int = 0; i < dataSource_.count(); i++) {
            num = num + (dataSource_.get(field, index:i) as CGFloat)
        }
        return num
    }
    
    private func applyLayoutConstraints_() {
        // apply height constraint for animation
        constraint_ = NSLayoutConstraint(
            item: datePickerContainer,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: 0)
        
        self.view.addConstraint(constraint_!)
    }
    
    private func refreshDataSource_(date: Int) {
        
        if (date < 0) {
            dataSource_.reload()
            return
        }
        
        dataSource_
            .setPredicate(
                ChartPredicates.yearly(year: date))
            .reload()
    }
    
    private func refreshDataSource_(beginDate:NSDate, endDate:NSDate) {
        dataSource_
            .setPredicate(
                ChartPredicates.customDateRange(beginDate, end: endDate))
            .reload()
    }
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // build the chart
        let newGraph = CPTXYGraph()
        newGraph.applyTheme(GraphThemes.PieChart)
        hostingView.hostedGraph = newGraph
        
        // pie chart settings
        piePlot = CPTPieChart()
        piePlot.dataSource      = self
        piePlot.delegate        = self
        piePlot.pieRadius       = 90.0
        piePlot.identifier      = "Pie Chart 1"
        piePlot.startAngle      = CGFloat(M_PI_4)
        piePlot.sliceDirection  = .CounterClockwise
        piePlot.centerAnchor    = CGPoint(x: 0.5, y: 0.5)
        piePlot.borderLineStyle = GraphThemes.PieChartLineStyle
        
        // add pie chart
        newGraph.addPlot(piePlot)
        
        self.pieGraph = newGraph
        
        // display
        self.dateTextIndicator.text = displayString_
        
        applyLayoutConstraints_()
        
        // set calendar button image
        changeDateButton.setBackgroundImage(calendarImg_, forState: UIControlState.Normal)
        
    
    }
    
    override func viewDidAppear(animated : Bool)
    {
        println("view did appear")
        super.viewDidAppear(animated)
        
        refreshDataSource_(-1)
        
        piePlot.reloadData()
        legendViewController_?.reloadData()
        
        tertiaryStatusBar.text = "Total: \(totalValue_(reportTypes[report.selectedSegmentIndex]))"
        
    }

    // MARK: - DatePickerDelegate Methods
    
    func datesSelected(beginDate:NSDate?, endDate:NSDate?) {
    /*
        Conditions:
        1) Both have dates
            -- update show dates
        2) Only beginDate is populated
            -- update show date to, "Trips for {date}"
        3) Both are nil
            -- return
    */
        
        var begin:NSString! = beginDate?.dateToString("MM-dd-yyyy")
        var end:NSString! = endDate?.dateToString("MM-dd-yyyy")
        
        if (begin != nil && end != nil) {
            dateTextIndicator.text = "Trips from: \(begin) to: \(end)"
            refreshDataSource_(
                beginDate!,
                endDate:endDate!)
        } else if (begin != nil) {
            dateTextIndicator.text = "Trips on \(begin)"
            refreshDataSource_(
                beginDate!,
                endDate:beginDate!)
        } else {
            return
        }
        
        displayString_ = dateTextIndicator.text
        
        // close up display
        self.changeDateMode_ = !self.changeDateMode_
        toggleDatePicker_(self.changeDateMode_)
        changeDateButton.setBackgroundImage(calendarImg_, forState: UIControlState.Normal)
        
        piePlot.reloadData()
        legendViewController_?.reloadData()
    
        tertiaryStatusBar.text = "Total: \(totalValue_(reportTypes[report.selectedSegmentIndex]))"
        
    }
    
    // MARK: - Plot Data Source Methods
    
    func legendTitleForPieChart(pieChart:CPTPieChart, recordIndex:UInt) -> NSString {
        return dataSource_.get("trip", index: Int(recordIndex)) as NSString
    }
    
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        return UInt(dataSource_.count())
    }
    
    func numberForPlot(plot: CPTPlot!, field: UInt, recordIndex: UInt) -> AnyObject! {
        if Int(recordIndex) > dataSource_.count() {
            return nil
        }
        else {
            switch (field) {
            case 0:
                return dataSource_.get(
                    reportTypes[report.selectedSegmentIndex],
                    index: Int(recordIndex)) as NSNumber
            default:
                return recordIndex as NSNumber
            }
        }
    }
    
    func radialOffsetForPieChart(piePlot: CPTPieChart!, recordIndex: UInt) -> CGFloat
    {
        return 2
    }
   
    // MARK: - Delegate Methods
    
    func pieChart(plot: CPTPlot!, sliceWasSelectedAtRecordIndex recordIndex: UInt)
    {
        println("select slice")
        println(dataSource_.count())
        var value = dataSource_.get(
            reportTypes[report.selectedSegmentIndex],
            index: Int(recordIndex)) as NSNumber
        statusBar.text = "Value: \(value)"
        
        // CRAP: No likey global static
        idx = recordIndex
        // force a redraw
        piePlot.reloadData()

    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var value:NSNumber = dataSource_.get(
            reportTypes[report.selectedSegmentIndex],
            index: Int(indexPath.row)) as NSNumber
        statusBar.text = "Value: \(value)"
        
        println("Value: \(value)")
        
        // CRAP: No likey global static
        idx = UInt(indexPath.row)
        // force a redraw
        piePlot.reloadData()

    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      println(segue.destinationViewController)
      println(segue.identifier)
        
        if (segue.identifier == "segue_embed_legend") {
            let legendController:LegendTableViewController = segue.destinationViewController as LegendTableViewController
            
            legendController.delegate = self
            legendController.setDataSource(dataSource_)
            
            // CRAP: THIS IS JUNK
            legendViewController_ = legendController
        }
    
        if (segue.identifier == "segue_embed_datePicker") {
            let datePickerController:DatePickerViewController = segue.destinationViewController as DatePickerViewController
            
            datePickerController.datePickerDelegate = self
        }
    }
    
}
