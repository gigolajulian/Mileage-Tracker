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
    
    let dataForChart = [20.0, 30.0, 60.0, 83.0,1.0]
    
    // MARK: Initialization
    
    override func viewDidAppear(animated : Bool)
    {
        super.viewDidAppear(animated)
        
        // Create graph from theme
        let newGraph = CPTXYGraph()
        newGraph.applyTheme(CPTTheme(named: kCPTDarkGradientTheme))
        
        hostingView.hostedGraph = newGraph
        
        // Paddings
        newGraph.paddingLeft   = 20.0
        newGraph.paddingRight  = 20.0
        newGraph.paddingTop    = 20.0
        newGraph.paddingBottom = 20.0
        
        newGraph.axisSet = nil
        
        let whiteText = CPTMutableTextStyle()
        whiteText.color = CPTColor.whiteColor()
        
        newGraph.titleTextStyle = whiteText
        newGraph.title          = "Graph Title"
        
        // Add pie chart
        let piePlot = CPTPieChart()
        piePlot.dataSource      = self
        piePlot.pieRadius       = 131.0
        piePlot.identifier      = "Pie Chart 1"
        piePlot.startAngle      = CGFloat(M_PI_4)
        piePlot.sliceDirection  = .CounterClockwise
        piePlot.centerAnchor    = CGPoint(x: 0.5, y: 0.38)
        piePlot.borderLineStyle = CPTLineStyle()
        piePlot.delegate        = self
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
