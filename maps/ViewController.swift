//
//  ViewController.swift
//  maps
//
//  Created by Ekrem Doğan on 13.01.2015.
//  Copyright (c) 2015 Ekrem Doğan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var myMap: MKMapView!
    var manager = CLLocationManager()
    var annotationY = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lat = NSString(string: places[activePlace]["lat"]!).doubleValue
        let lon = NSString(string: places[activePlace]["lon"]!).doubleValue
        
        var latitude:CLLocationDegrees = lat
        var longitute:CLLocationDegrees = lon
        var latDelta:CLLocationDegrees = 0.01
        var lonDelta:CLLocationDegrees = 0.01
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitute)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        myMap.setRegion(region, animated: true)

        annotationY.coordinate = location
        annotationY.title = places[activePlace]["name"]
        
        myMap.addAnnotation(annotationY)
        

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        /*
        var latitude:CLLocationDegrees = 40.748655
        var longitute:CLLocationDegrees = -73.985621
        var latDelta:CLLocationDegrees = 0.01
        var lonDelta:CLLocationDegrees = 0.01
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitute)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        myMap.setRegion(region, animated: true)
        
        var annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "Empire State Building"
        annotation.subtitle = "This is subtitle"
        
        myMap.addAnnotation(annotation)
        */
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 2.0
        myMap.addGestureRecognizer(uilpgr)

    }
    
    @IBAction func findMePressed(sender: AnyObject) {
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            // annotation code
            // this will be run only once by long press

            var touchPoint = gestureRecognizer.locationInView(self.myMap)
            var newCoordinate:CLLocationCoordinate2D = myMap.convertPoint(touchPoint, toCoordinateFromView: self.myMap)
        
            var newAnnotation = MKPointAnnotation()
        
            newAnnotation.coordinate = newCoordinate
            newAnnotation.title = "Empire State Building"
            newAnnotation.subtitle = "This is subtitle"
        
            myMap.addAnnotation(newAnnotation)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        myMap.removeAnnotation(annotationY)
        var userLocation:CLLocation = locations[0] as CLLocation
        
        var latitude:CLLocationDegrees = userLocation.coordinate.latitude
        var longitute:CLLocationDegrees = userLocation.coordinate.longitude
        var latDelta:CLLocationDegrees = 0.01
        var lonDelta:CLLocationDegrees = 0.01
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitute)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        myMap.setRegion(region, animated: true)
        
        manager.stopUpdatingLocation()
        
        annotationY.coordinate = location
        annotationY.title = "you're here"
        annotationY.subtitle = "This is subtitle"
        
        myMap.addAnnotation(annotationY)
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("location error: \(error)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

