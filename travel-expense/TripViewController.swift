//
//  TripViewController.swift
//  travel-expense
//
//  Created by Saan Saeteurn on 11/23/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import UIKit

class TripViewController: UIViewController, UITextFieldDelegate {
    
    let coreData: TripDataModel = TripDataModel()
    
    @IBOutlet var textFieldTrip: UITextField!
    @IBOutlet var textFieldOrigin: UITextField!
    @IBOutlet var textFieldDestination: UITextField!
    @IBOutlet var textFieldDeparture: UITextField!
    @IBOutlet var textFieldArrival: UITextField!
    @IBOutlet var textFieldTotalDistance: UITextField!
    @IBOutlet var textFieldTotalCost: UITextField!
    @IBOutlet var textFieldTripDescription: UITextField!
    
    var trip : String = ""
    var origin : String = ""
    var destination : String = ""
    var departureDate : String = ""
    var arrivalDate : String = ""
    var totalDistance : String = ""
    var totalCost : String = ""
    var tripDescription : String = ""

    // Trip object to represent existing trip to update.
    var existingTripObject: Trip!
    
    @IBAction func arrivalDatePicker(sender: UITextField) {
        // Create a date pick for arrival date field.
        
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("arrivaDateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func departureDatePicker(sender: UITextField) {
        // Create a date picker for departure date field.
        
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("departureDateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }

    func arrivaDateChanged(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        textFieldArrival.text = dateFormatter.stringFromDate(sender.date)
    }

    func departureDateChanged(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        textFieldDeparture.text = dateFormatter.stringFromDate(sender.date)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set text fields to clear keyboard on 'return' key.
        textFieldTrip.delegate = self
        textFieldOrigin.delegate = self
        textFieldDestination.delegate = self
        textFieldDeparture.delegate = self
        textFieldArrival.delegate = self
        textFieldTotalDistance.delegate = self
        textFieldTotalCost.delegate = self
        textFieldTripDescription.delegate = self
        
        if (existingTripObject != nil) {
            textFieldTrip.text = trip
            textFieldOrigin.text = origin
            textFieldDestination.text = destination
            textFieldDeparture.text = departureDate
            textFieldArrival.text = arrivalDate
            textFieldTotalDistance.text = totalDistance
            textFieldTotalCost.text = totalCost
            textFieldTripDescription.text = tripDescription
        }
    }
    
    @IBAction func buttonCancel(sender: AnyObject) {
        println("Cancel Button Pressed")
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func butttonSave(sender: AnyObject) {
        /*
        On button click, do the followings:
        
        1. Get NSManageObjectContext(moc) from our app delegate.
        2a. Create a new Trip instance using our entity and context objecets.
        2b. Set the outlet data to our Trip object's attributes.
        3. Save our Trip object back into our data model.
        4. Navigate back to our main view controller.
        */
        
        println("Save Button Pressed \(textFieldTrip.text).")
        
        // 1. Get NSManageObjectContext(moc) from our app delegate.
        let context = coreData.getManageObjectContext()
        
        // 2a. Set current Trip object if it exists.
        if (existingTripObject != nil) {
            existingTripObject.trip = textFieldTrip.text
            existingTripObject.origin = textFieldOrigin.text
            existingTripObject.destination = textFieldDestination.text
            existingTripObject.departureDate = textFieldDeparture.text
            existingTripObject.arrivalDate = textFieldArrival.text
            existingTripObject.totalDistance = textFieldTotalDistance.text
            existingTripObject.totalCost = textFieldTotalCost.text
            existingTripObject.tripDescription = textFieldTripDescription.text
            
        } else {
            // 2b. Create a new instance to our data model.
            var newTripObject = coreData.getNewTripObject()
            
            // 3. Map our properties.
            println(textFieldTrip.text)
            newTripObject.trip = textFieldTrip.text
            newTripObject.origin = self.textFieldOrigin.text
            newTripObject.destination = textFieldDestination.text
            newTripObject.departureDate = textFieldDeparture.text
            newTripObject.arrivalDate = textFieldArrival.text
            newTripObject.totalDistance = textFieldTotalDistance.text
            newTripObject.totalCost = textFieldTotalCost.text
            newTripObject.tripDescription = textFieldTripDescription.text
            
            println(newTripObject)
            println("New TaskItem Object Saved.")
        }
        
        // 3. Save our TaskItem object back into our data model.
        context.save(nil)
        
        // 4. Navigate back to our main view controller.
        self.navigationController?.popToRootViewControllerAnimated(true)
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
