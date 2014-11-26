//
//  PieChartViewController.swift
//  travel-expense
//
//  Created by MLayman on 11/25/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import UIKit

class PieChartViewController: UIViewController, CPTPieChartDataSource {
    
    @IBOutlet var hostingView:CPTGraphHostingView!
    @IBOutlet var statusBar:UILabel!
    
    private var pieGraph : CPTXYGraph? = nil
    private var theme_:CPTTheme! = nil
    
    let dataForChart = [20.0, 30.0, 60.0, 83.0,1.0]
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
    }
    
    override func viewDidAppear(animated : Bool)
    {
        super.viewDidAppear(animated)
        
        let newGraph = CPTXYGraph()
        newGraph.applyTheme(theme_)
        hostingView.hostedGraph = newGraph
        
        newGraph.title          = "Graph Title"
        
        // pie chart settings
        let piePlot = CPTPieChart()
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
