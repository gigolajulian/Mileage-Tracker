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

class DatePickerViewController: UIViewController, UITextFieldDelegate {

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
        
        beginDate.delegate = self
        endDate.delegate = self
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        // Hide keyboard when clicking away from text field.
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide keyboard when 'return' key is pressed.
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func reset_() {
        self.beginDate.text = ""
        self.endDate.text = ""
    }
}
