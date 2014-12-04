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
UITableViewDataSource,
UITableViewDelegate
{
    
    private let coreData_:TripDataModel = TripDataModel()
    private var pieGraph : CPTXYGraph? = nil
    private var piePlot:CPTPieChart!
    private var chartData_:[Trip] = []
    
    @IBOutlet var hostingView:CPTGraphHostingView!
    @IBOutlet var statusBar:UILabel!
    @IBOutlet var testYear:UITextField!
    @IBOutlet var legend:UITableView!
    @IBOutlet var report:UISegmentedControl!
    
    private var reportTypes:[NSString] = ["distance","cost"]
    
    @IBAction func reportChange(sender: UISegmentedControl) {
        println(sender.selectedSegmentIndex)
        // send change report event
        chartData_.removeAll(keepCapacity: true)
        legend.reloadData()
        chartData_.extend(fetchData_())
        
        println("change report reload table: \(self.chartData_.count)")
        
        piePlot.reloadData()
        legend.reloadData()
    }
    
    func changeYear(sender: UIButton) {
        // TODO: Clean up refresh
        chartData_.removeAll(keepCapacity: true)
        chartData_.extend(
            fetchData_(year: (self.testYear.text as NSString).integerValue))
        
        println("change date reload table: \(self.chartData_.count)")
        
        piePlot.reloadData()
        legend.reloadData()
    }

    private func fetchData_(year:Int = 2014) -> [Trip]
    {
        
        let req = coreData_.getFetchRequest()
        
        req.predicate = ChartPredicates.yearly(year: year)
        
        // execute fetch request
        var error:NSError?
        let ctx = coreData_.getManageObjectContext()
        var data = ctx.executeFetchRequest(req, error: &error) as [Trip]
        
        if (error == nil) {
            return data
        } else {
            println(error)
        }
        return []
    }
    
    private func refreshDataSource_(date:Int) {
        chartData_.removeAll(keepCapacity: true)
        chartData_.extend(fetchData_(year: date))
    }
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // link the legend to the datasource
        legend.dataSource = self
        legend.delegate = self
        
        // build the chart
        let newGraph = CPTXYGraph()
        newGraph.applyTheme(GraphThemes.PieChart)
        hostingView.hostedGraph = newGraph
        
        // pie chart settings
        piePlot = CPTPieChart()
        piePlot.dataSource      = self
        piePlot.delegate        = self
        piePlot.pieRadius       = 125.0
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
        
        let date:Int = ((self.testYear.text as NSString).integerValue == 0) ?
            2014 :
            (self.testYear.text as NSString).integerValue
        
        refreshDataSource_(date)
        piePlot.reloadData()
        legend.reloadData()
    }
    
    // MARK: - Plot Data Source Methods
    
    func legendTitleForPieChart(pieChart:CPTPieChart, recordIndex:UInt) -> NSString {
        return chartData_[Int(recordIndex)].trip
    }
    
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        return UInt(chartData_.count)
    }
    
    func numberForPlot(plot: CPTPlot!, field: UInt, recordIndex: UInt) -> AnyObject! {
        if Int(recordIndex) > chartData_.count {
            return nil
        }
        else {
            switch (field) {
            case 0:
                // TODO SWITCH HERE
                return selectedDataField_(
                    reportTypes[report.selectedSegmentIndex],
                    index: Int(recordIndex))
            default:
                return recordIndex as NSNumber
            }
        }
    }
    
    private func selectedDataField_(field:NSString, index:Int) -> AnyObject! {
        switch(field) {
            case "cost":
                return chartData_[index].totalCost as NSNumber
            case "distance":
                return chartData_[index].totalDistance as NSNumber
            default:
                return 0 as NSNumber
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
    
    // CRAP: No likey global static
    var idx:UInt = 100000
    
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
        return offset
    }
   
    // MARK: - Delegate Methods
    
    func pieChart(plot: CPTPlot!, sliceWasSelectedAtRecordIndex recordIndex: UInt)
    {
        println("select slice")
        
        //debug: self.pieGraph?.title = "Selected index: \(recordIndex)"
        
        statusBar.text = "DEV Value: \(selectedDataField_(reportTypes[report.selectedSegmentIndex], index:Int(recordIndex))) | Selected index: \(recordIndex)"
        // CRAP: No likey global static
        idx = recordIndex
        // force a redraw
        piePlot.reloadData()

    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(chartData_.count)
        println("select")
        // CRAP: No likey global static
        idx = UInt(indexPath.row)
        // force a redraw
        piePlot.reloadData()

    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        println("refresh: \(chartData_.count)")
        return chartData_.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:LegendTableViewCell = tableView
            .dequeueReusableCellWithIdentifier(
                "reuseIdentifier",
                forIndexPath: indexPath) as LegendTableViewCell
        
        let tripObj:Trip = chartData_[indexPath.row]
        cell.title.text = tripObj.trip
        cell.subTitle.text = coreData_.dateFormatter
            .stringFromDate(tripObj.tripDate)
        
        let color:UIColor = CPTPieChart.defaultPieSliceColorForIndex(UInt(indexPath.row)).uiColor

        cell.leftBorder.backgroundColor = color
    
        println("###")
        println(chartData_.count)
        
        return cell
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
