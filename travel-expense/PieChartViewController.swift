//
//  PieChartViewController.swift
//  travel-expense
//
//  Created by MLayman on 11/25/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

/*
todo:

-legend (as seperate table?)
-stylings and chart labeling
-monthly yearly aggregates
-2nd bar chart
-input date intervals
-show data for picked data
-BUG: date change does not update legend table
*/

import UIKit

class PieChartViewController:
UIViewController,
CPTPieChartDataSource,
UITableViewDelegate
{
    
    private let coreData_:TripDataModel = TripDataModel()
    private var pieGraph : CPTXYGraph? = nil
    private var piePlot:CPTPieChart!
    private let dataSource_:CoreDataSource = CoreDataSource()
    // CRAP: No likey global static
    private var idx:UInt = 100000
    private var reportTypes:[NSString] = ["totalDistance","totalCost"]
    
    @IBOutlet var hostingView:CPTGraphHostingView!
    @IBOutlet var statusBar:UILabel!
    @IBOutlet var beginDate:UITextField!
    @IBOutlet var endDate:UITextField!
    @IBOutlet var report:UISegmentedControl!
    
    @IBAction func reportChange(sender: UISegmentedControl) {
        println(sender.selectedSegmentIndex)
        //refreshDataSource_(-1)
        piePlot.reloadData()
    }
    
    @IBAction func changeDate(sender: UIButton) {
        
        println(coreData_.dateFormatter.dateFromString(beginDate.text))
        
        refreshDataSource_(
            coreData_.dateFormatter.dateFromString(beginDate.text)!,
            endDate: coreData_.dateFormatter.dateFromString(endDate.text)!)
            
    // (self.testYear.text as NSString).integerValue)
        piePlot.reloadData()
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
        
        /*
        if (date < 0) {
            dataSource_.reload()
            return
        }
        */
        
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
        piePlot.pieRadius       = 85.0
        piePlot.identifier      = "Pie Chart 1"
        piePlot.startAngle      = CGFloat(M_PI_4)
        piePlot.sliceDirection  = .CounterClockwise
        piePlot.centerAnchor    = CGPoint(x: 0.5, y: 0.5)
        piePlot.borderLineStyle = GraphThemes.PieChartLineStyle
        
        // add pie chart
        newGraph.addPlot(piePlot)
        
        self.pieGraph = newGraph
    }
    
    override func viewDidAppear(animated : Bool)
    {
        println("view did appear")
        super.viewDidAppear(animated)
        
        /*
        let date:Int = ((self.testYear.text as NSString).integerValue == 0) ?
            2014 :
            (self.testYear.text as NSString).integerValue
        */
        
        if (beginDate.text.isEmpty) {
            refreshDataSource_(2014)
        } else {
            println("got")
            refreshDataSource_(
                coreData_.dateFormatter.dateFromString(beginDate.text)!,
                endDate: coreData_.dateFormatter.dateFromString(endDate.text)!)
        }
        piePlot.reloadData()
    }
    
    // MARK: - Plot Data Source Methods
    
    func legendTitleForPieChart(pieChart:CPTPieChart, recordIndex:UInt) -> NSString {
        return dataSource_.get("trip", index: Int(recordIndex)) as NSString
    }
    
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        println("count: \(dataSource_.count())")
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
    
    func dataLabelForPlot(plot: CPTPlot!, recordIndex: UInt) -> CPTLayer!
    {
        let label = CPTTextLayer(text:"\(recordIndex)")
        
        let textStyle = label.textStyle.mutableCopy() as CPTMutableTextStyle
        textStyle.color = CPTColor.lightGrayColor()
        
        label.textStyle = textStyle
        
        return nil
    }
    
    
    func radialOffsetForPieChart(piePlot: CPTPieChart!, recordIndex: UInt) -> CGFloat
    {
        //println("offset")
        var offset: CGFloat = 0.0
        
        if ( recordIndex == idx ) {
            // pulls out a slice
            offset = piePlot.pieRadius / 4.0
        } else {
            offset = 2 //piePlot.pieRadius / 10.0
        }
        //println(offset)
        offset = 2
        return offset
    }
   
    // MARK: - Delegate Methods
    
    func pieChart(plot: CPTPlot!, sliceWasSelectedAtRecordIndex recordIndex: UInt)
    {
        println("select slice")
        
        var value = dataSource_.get(
            reportTypes[report.selectedSegmentIndex],
            index: Int(recordIndex)) as? NSString
        statusBar.text = "DEV Value: \(value)"
        
        // CRAP: No likey global static
        idx = recordIndex
        // force a redraw
        piePlot.reloadData()

    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var value = dataSource_.get(
            reportTypes[report.selectedSegmentIndex],
            index: Int(indexPath.row)) as? NSString
        statusBar.text = "DEV Value: \(value)"
        
        //println(chartData_.count)
        println(dataSource_.count())
        // CRAP: No likey global static
        idx = UInt(indexPath.row)
        // force a redraw
        piePlot.reloadData()

    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "segue_embed_legend") {
            let legendController:LegendTableViewController = segue.destinationViewController as LegendTableViewController
            
            legendController.delegate = self
            legendController.setDataSource(dataSource_)
        }
    
    }
    
}
