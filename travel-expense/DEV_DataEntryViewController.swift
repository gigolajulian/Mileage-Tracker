//
//  FOR DEVELOPMENT PURPOSES ONLY. NOT FOR RELEASE.
//
//  DEV_DataEntryViewController.swift
//  travel-expense
//
//  Created by MLayman on 11/26/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import UIKit

class DEV_DataEntryViewController: UIViewController {

    private let coreData: TripDataModel = TripDataModel()
    
    @IBOutlet var nameTextbox:UITextField!
    @IBOutlet var costTextbox:UITextField!
    @IBOutlet var datePick:UIDatePicker!
    
    @IBAction func submitData(sender:UIButton!) {
        println("dev - submit")
        
        let ctx = coreData.getManageObjectContext()
        var obj = coreData.getNewTripObject()
        obj.trip = nameTextbox.text
        obj.zDev_totalCost = (costTextbox.text as NSString).floatValue
        obj.zDev_arrivalDate = datePick.date
        
        var error:NSError?
        ctx.save(&error)
        
        if (error != nil) {
            println(error)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
