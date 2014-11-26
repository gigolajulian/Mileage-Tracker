//
//  GraphTheme.swift
//  travel-expense
//
//  Created by mlayman on 11/25/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

class GraphTheme : CPTTheme {
    
    typealias BACKGROUND_THEME_FUNC = (CPTGraph)->()
    typealias AXIS_SET_THEME_FUNC = (CPTAxisSet)->()
    typealias PLOT_AREA_THEME_FUNC = (CPTPlotAreaFrame)->()
    
    private lazy var backgroundThemeFunc:BACKGROUND_THEME_FUNC = { $0; return }
    private lazy var axisSetThemeFunc:AXIS_SET_THEME_FUNC = { $0; return }
    private lazy var plotAreaThemeFunc:PLOT_AREA_THEME_FUNC = { $0; return }
    

    func setBackground(function:BACKGROUND_THEME_FUNC) -> GraphTheme {
        self.backgroundThemeFunc = function
        return self
    }
    
    func setAxisSet(function:AXIS_SET_THEME_FUNC) -> GraphTheme {
        self.axisSetThemeFunc = function
        return self
    }

    func setPlotArea(function:PLOT_AREA_THEME_FUNC) -> GraphTheme {
        self.plotAreaThemeFunc = function
        return self
    }
    
    override func newGraph() -> AnyObject? {
        let graph:CPTXYGraph = CPTXYGraph()
        return graph
    }
    
    override func applyThemeToBackground(graph:CPTGraph) {
        self.backgroundThemeFunc(graph)
    }
    
    override func applyThemeToPlotArea(plotAreaFrame:CPTPlotAreaFrame) {
        self.plotAreaThemeFunc(plotAreaFrame)
    }
    
    override func applyThemeToAxisSet(axisSet:CPTAxisSet) {
        self.axisSetThemeFunc(axisSet)
    }
    
}