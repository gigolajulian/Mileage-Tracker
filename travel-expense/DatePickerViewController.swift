//
//  DatePickerViewController.swift
//  travel-expense
//
//  Created by cisstudents on 12/5/14.
// Authors:
// Abi Kasraie
// Julian Gigola
// Michael Layman
// Saan Saeteurn
//
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet var beginDate:UITextField!
    @IBOutlet var endDate:UITextField!
    
    var datePickerDelegate:DatePickerDelegate?
    
    @IBAction func datesSelected(sender: UIButton) {
        
        if (self.datePickerDelegate == nil) {
            return
        }
        
        var end = (endDate.text.isEmpty) ?
            nil :
            self.endDate.text.stringToDate("MM-dd-yyyy")
        
        self.datePickerDelegate?.datesSelected!(
            self.beginDate.text.stringToDate("MM-dd-yyyy"),
            endDate: end)
        
        reset_()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func reset_() {
        self.beginDate.text = ""
        self.endDate.text = ""
    }
}
