//
//  GraphThemes.swift
//  travel-expense
//
//  Created by cisstudents on 12/2/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import Foundation

struct GraphThemes {
    
    static let PieChartLineStyle:CPTLineStyle! = {
        return CPTLineStyle()
    }()
    
    static let PieChart:CPTTheme! = {
        
        return (GraphTheme())
            .setBackground({
                (graph:CPTGraph) in
                //graph.fill = CPTFill(color:CPTColor.redColor())
                // Paddings
                graph.paddingLeft   = 5.0
                graph.paddingRight  = 5.0
                graph.paddingTop    = 5.0
                graph.paddingBottom = 5.0
                // font styles
                //var whiteText:CPTMutableTextStyle = CPTMutableTextStyle()
                //whiteText.color = CPTColor.whiteColor()
                //graph.titleTextStyle = whiteText 
            })
            .setAxisSet({
                (axisSet:CPTAxisSet) in
                let xyAxisSet:CPTXYAxisSet = axisSet as CPTXYAxisSet
                
                // x and y axis not drawn
                xyAxisSet.xAxis.axisLineStyle = nil
                xyAxisSet.yAxis.axisLineStyle = nil })
            .setPlotArea({
                (plotAreaFrame:CPTPlotAreaFrame) in
                //plotAreaFrame.fill = CPTFill(color:CPTColor.cyanColor())
            })
    }()
}