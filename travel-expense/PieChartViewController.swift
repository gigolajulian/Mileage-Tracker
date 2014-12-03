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

*/

import UIKit

class PieChartViewController: UIViewController, CPTPieChartDataSource, UITableViewDataSource,
UITableViewDelegate
{
    
    private let coreData_:TripDataModel = TripDataModel()
    private var pieGraph : CPTXYGraph? = nil
    private var piePlot:CPTPieChart!
    private var chartData_:[Trip] = []
    
    @IBOutlet var hostingView:CPTGraphHostingView!
    @IBOutlet var statusBar:UILabel!
    @IBOutlet var testYear:UITextField!
    @IBOutlet var container:UITableView!
    
    
    func changeYear(sender: UIButton) {
        // TODO: Clean up refresh
        chartData_.removeAll(keepCapacity: true)
        chartData_.extend(
            fetchData_(year: (self.testYear.text as NSString).integerValue))
        piePlot.reloadData()
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
    
    private func refreshDataSource_() {
        chartData_.removeAll(keepCapacity: true)
        chartData_.extend(fetchData_())
    }
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // link the legend to the datasource
        container.dataSource = self
        container.delegate = self
        
        // build the chart
        let newGraph = CPTXYGraph()
        newGraph.applyTheme(GraphThemes.PieChart)
        hostingView.hostedGraph = newGraph
        
        newGraph.title          = "Graph Title"
        
        // pie chart settings
        piePlot = CPTPieChart()
        piePlot.dataSource      = self
        piePlot.delegate        = self
        piePlot.pieRadius       = 131.0
        piePlot.identifier      = "Pie Chart 1"
        piePlot.startAngle      = CGFloat(M_PI_4)
        piePlot.sliceDirection  = .CounterClockwise
        piePlot.centerAnchor    = CGPoint(x: 0.5, y: 0.38)
        piePlot.borderLineStyle = GraphThemes.PieChartLineStyle
        
        // add pie chart
        newGraph.addPlot(piePlot)
        
        self.pieGraph = newGraph
        
        // add legend
        //let legend:CPTLegend = CPTLegend(graph:newGraph)
        //legend.numberOfColumns = 1
        //legend.borderLineStyle = GraphThemes.PieChartLineStyle
        //legend.cornerRadius = 5.0
        //newGraph.legend = legend
        
        //println((container.subviews[0] as UITableView).c)
    }
    
    override func viewDidAppear(animated : Bool)
    {
        println("view did appear")
        
        super.viewDidAppear(animated)
        
        // reload data
        refreshDataSource_()
        piePlot.reloadData()
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
                return chartData_[Int(recordIndex)].totalCost as NSNumber
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
    
    // CRAP: No likey global static
    var idx:UInt = 100000
    
    func radialOffsetForPieChart(piePlot: CPTPieChart!, recordIndex: UInt) -> CGFloat
    {
        //println("offset")
        var offset: CGFloat = 0.0
        
        if ( recordIndex == idx ) {
            // pulls out a slice
            offset = piePlot.pieRadius / 4.0
        }
        //println(offset)
        return offset
    }
   
    // MARK: - Delegate Methods
    
    func pieChart(plot: CPTPlot!, sliceWasSelectedAtRecordIndex recordIndex: UInt)
    {
        println("select slice")
        self.pieGraph?.title = "Selected index: \(recordIndex)"
        statusBar.text = "Value: \(chartData_[Int(recordIndex)].totalCost) | Selected index: \(recordIndex)"
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
        refreshDataSource_()
        println("refresh")
        return chartData_.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        // Configure the cell...
        cell.textLabel?.text = chartData_[indexPath.row].trip
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
