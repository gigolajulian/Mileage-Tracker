//
//  PieChartViewController.swift
//  travel-expense
//
//  Created by MLayman on 11/25/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import UIKit

class PieChartViewController: UIViewController, CPTPieChartDataSource {
    
    private let coreData_:TripDataModel = TripDataModel()
    
    @IBOutlet var hostingView:CPTGraphHostingView!
    @IBOutlet var statusBar:UILabel!
    @IBOutlet var testYear:UITextField!
    
    @IBAction func changeYear(sender: UIButton) {
        
        // https://github.com/vandadnp/iOS-8-Swift-Programming-Cookbook/blob/master/chapter-concurrency/Grouping%20Tasks%20Together/Grouping%20Tasks%20Together/ViewController.swift
        
        let taskGroup = dispatch_group_create()
        let mainQueue = dispatch_get_main_queue()
        /* Reload the table view on the main queue */
        dispatch_group_async(taskGroup, mainQueue, {[weak self] in
            println("get it... again")
            self!.dataForChart.removeAll(keepCapacity: true)
            self!.fetchData(year: (self!.testYear.text as NSString).integerValue)
            self!.piePlot.reloadData()
        });
        
    }
    
    private var pieGraph : CPTXYGraph? = nil
    private var theme_:CPTTheme! = nil
    private var piePlot:CPTPieChart!
    var dataForChart:[Float] = []
    
    func fetchData(year:Int = 2014) {
        
        let req = coreData_.getFetchRequest()
        
        // create query date for the year 2014
        let caln:NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let startcomp:NSDateComponents = NSDateComponents()
        startcomp.year = year
        startcomp.month = 1
        startcomp.day = 1
        startcomp.hour = 0
        startcomp.minute = 0
        startcomp.second = 0
        let startDate:NSDate! = caln.dateFromComponents(startcomp)
        
        let endcomp:NSDateComponents = NSDateComponents()
        endcomp.year = year
        endcomp.month = 12
        endcomp.day = 31
        endcomp.hour = 23
        endcomp.minute = 59
        endcomp.second = 59
        let endDate:NSDate! = caln.dateFromComponents(endcomp)
        
        // assign predicate
        let startpredicate:NSPredicate = NSPredicate(format: "(zDev_arrivalDate >= %@)",startDate)
        let endpredicate:NSPredicate = NSPredicate(format: "(zDev_arrivalDate <= %@)",endDate)
        req.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [startpredicate,endpredicate])
    
        // execute fetch request
        var error:NSError?
        let ctx = coreData_.getManageObjectContext()
        let result = ctx.executeFetchRequest(req, error: &error) as [Trip]
        
        if (error == nil) {
            // load numbers into data
            for (var i = 0, len = result.count; i < len; i++) {
                var e:Trip = result[i]
                dataForChart.append(e.zDev_totalCost)
            }
        } else {
            println(error)
        }
    }
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let taskGroup = dispatch_group_create()
        let mainQueue = dispatch_get_main_queue()
        /* Reload the table view on the main queue */
        dispatch_group_async(taskGroup, mainQueue, {[weak self] in
            //self!.fetchData()
            println("get it...")
            self!.fetchData()
            self!.hostingView.setNeedsDisplay()

        });
        
        
        theme_ = (GraphTheme())
            .setBackground({
                (graph:CPTGraph) in
                graph.fill = CPTFill(color:CPTColor.redColor())
                // Paddings
                graph.paddingLeft   = 5.0
                graph.paddingRight  = 5.0
                graph.paddingTop    = 5.0
                graph.paddingBottom = 5.0
                // font styles
                var whiteText:CPTMutableTextStyle = CPTMutableTextStyle()
                whiteText.color = CPTColor.whiteColor()
                graph.titleTextStyle = whiteText })
            .setAxisSet({
                (axisSet:CPTAxisSet) in
                let xyAxisSet:CPTXYAxisSet = axisSet as CPTXYAxisSet
                
                // x and y axis not drawn
                xyAxisSet.xAxis.axisLineStyle = nil
                xyAxisSet.yAxis.axisLineStyle = nil })
            .setPlotArea({
                (plotAreaFrame:CPTPlotAreaFrame) in
                plotAreaFrame.fill = CPTFill(color:CPTColor.grayColor())})
        
        //fetchData()
        
    }
    
    override func viewDidAppear(animated : Bool)
    {
        super.viewDidAppear(animated)
        
        let newGraph = CPTXYGraph()
        newGraph.applyTheme(theme_)
        hostingView.hostedGraph = newGraph
        
        newGraph.title          = "Graph Title"
        
        // pie chart settings
        piePlot = CPTPieChart()
        piePlot.dataSource      = self
        piePlot.pieRadius       = 131.0
        piePlot.identifier      = "Pie Chart 1"
        piePlot.startAngle      = CGFloat(M_PI_4)
        piePlot.sliceDirection  = .CounterClockwise
        piePlot.centerAnchor    = CGPoint(x: 0.5, y: 0.38)
        piePlot.borderLineStyle = CPTLineStyle()
        piePlot.delegate        = self
        
        // add pie chart
        newGraph.addPlot(piePlot)
        
        self.pieGraph = newGraph
        
        println("view did appear")
    }
    
    // MARK: - Plot Data Source Methods
    
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt
    {
        return UInt(self.dataForChart.count)
    }
    
    func numberForPlot(plot: CPTPlot!, field: UInt, recordIndex: UInt) -> AnyObject!
    {
        if Int(recordIndex) > self.dataForChart.count {
            return nil
        }
        else {
            switch (field) {
            case 0:
                return (self.dataForChart)[Int(recordIndex)] as NSNumber
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
        
        return label
    }
    
    func radialOffsetForPieChart(piePlot: CPTPieChart!, recordIndex: UInt) -> CGFloat
    {
        var offset: CGFloat = 0.0
        
        
        if ( recordIndex == 0 ) {
            // pulls out a slice
            offset = piePlot.pieRadius / 8.0
        }
        
        return offset
    }
   
    // MARK: - Delegate Methods
    
    func pieChart(plot: CPTPlot!, sliceWasSelectedAtRecordIndex recordIndex: UInt)
    {
        self.pieGraph?.title = "Selected index: \(recordIndex)"
        statusBar.text = "Value: \(dataForChart[Int(recordIndex)]) | Selected index: \(recordIndex)"
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
