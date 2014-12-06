//
//  MapViewController.swift
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
import MapKit
import Foundation
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    


    @IBOutlet var mapView: MKMapView!
    var origin : NSString!
    var destination : NSString!
    var tripName : NSString!
    var totalDistance : NSString!
    
    var originCLPlacemark : CLPlacemark!
    var currentPlacemark : CLPlacemark!
    var locationManager : CLLocationManager!
    
    
    @IBAction func buttonShowDirection(sender: AnyObject) {
        println("Direction button clicked.")
        
        var directionRequest : MKDirectionsRequest = MKDirectionsRequest()
        directionRequest.setSource(MKMapItem.mapItemForCurrentLocation())
        //self.setOriginPlacemark()
        //var originMKPlacemark : MKPlacemark = MKPlacemark(placemark: originCLPlacemark)
        //var originMapItem : MKMapItem = MKMapItem(placemark: originMKPlacemark)
        //directionRequest.setSource(originMapItem)
        
        var destinationMKPlacemark : MKPlacemark = MKPlacemark(placemark: currentPlacemark)
        var destinationMapItem: MKMapItem = MKMapItem(placemark: destinationMKPlacemark)
        directionRequest.setDestination(destinationMapItem)
        
        var direction : MKDirections = MKDirections(request: directionRequest)
        direction.calculateDirectionsWithCompletionHandler({
            (response:MKDirectionsResponse!, routeError:NSError!) -> Void in
            if (routeError != nil || response.routes.isEmpty) {
                return
            } else {
                let route: MKRoute = response.routes[0] as MKRoute
                self.mapView.addOverlay(route.polyline!)
                var rect : MKMapRect = route.polyline.boundingMapRect as MKMapRect
                
                let spanX = 0.8
                let spanY = 0.8
                var newRegion = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
                self.mapView.setRegion(newRegion, animated: true)
                
            }
        })
    }

    
    @IBAction func buttonDone(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let route: MKPolyline = overlay as MKPolyline
        let routeRenderer = MKPolylineRenderer(polyline:route)
        routeRenderer.lineWidth = 3.0
        routeRenderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        return routeRenderer
    }
    
    
    /* This method still buggy - Saan */
    func setOriginPlacemark() {
        // Use Geocoder to convert address into coordinate
        var geoCoder : CLGeocoder = CLGeocoder()
        geoCoder.geocodeAddressString(origin, completionHandler: { (placemarks: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                println("Geocode failed with error: \(error.description)")
                return
            }
            
            if (placemarks != nil && placemarks.count > 0) {
                self.originCLPlacemark = placemarks[0] as CLPlacemark
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up our Location Manager.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // Setup our Map View
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        // Use Geocoder to convert address into coordinate
        var geoCoder : CLGeocoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.destination, completionHandler: { (placemarks: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                println("Geocode failed with error: \(error.description)")
                return
            }
            
            if (placemarks != nil && placemarks.count > 0) {
                self.currentPlacemark = placemarks[0] as CLPlacemark
                
                // Add annotation
                var annotation : MKPointAnnotation = MKPointAnnotation()
                annotation.title = self.tripName
                annotation.subtitle = "Total Distance: \(self.totalDistance) miles"
                annotation.coordinate = self.currentPlacemark.location.coordinate
                
                // Zoom into the location
                var region : MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
                self.mapView.setRegion(region, animated: true)
                
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
                
            }
            
        })
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            
            if (error != nil) {
                println("Error: \(error.localizedDescription)")
                return
            }
            
            if placemarks.count > 0 {
                //let location = locations.last as CLLocation
                //println("didUpdateLocations's latlog:  \(location.coordinate.latitude), \(location.coordinate.longitude)")
                
                let placeMarkObject = placemarks[0] as CLPlacemark
                self.displayLocationInfo(placeMarkObject)
            }else {
                println("Error with data")
            }
            
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        self.locationManager.stopUpdatingHeading()
        let city : String = placemark.locality
        let state: String = placemark.administrativeArea
        let zip : String = placemark.postalCode
        println("\(city), \(state) \(zip)")
        println(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude)
        println(placemark.country)
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: \(error.localizedDescription)")
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let identifier = "MyPin"
        
        if annotation is MKUserLocation {
            // Return nil so map view draws "blue dot" for standard user location.
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.pinColor = .Purple
        }
        else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
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
