//
//  ReportViewController.swift
//  travel-expense
//
//  Created by Mileage Tracker Team on 11/23/14.
//  Authors:
//          Abi Kasraie
//          Julian Gigola
//          Michael Layman
//          Saan Saeteurn
//
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
    let coreData: TripDataModel = TripDataModel()
    var trips : Array<AnyObject> = []

    @IBOutlet var labelReports: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchReqest = coreData.getFetchRequest()
        var error: NSError?
        
        let fetchResults = coreData.getManageObjectContext().executeFetchRequest(fetchReqest, error: &error)
        if let results = fetchResults {
            trips = results
            labelReports.text = "There are \(trips.count) trips."
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
