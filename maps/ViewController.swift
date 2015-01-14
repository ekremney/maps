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
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activePlace == -1 {
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation()
        }
        else {
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
        }

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
            myMap.removeAnnotation(annotationY)
            // annotation code
            // this will be run only once by long press

            var touchPoint = gestureRecognizer.locationInView(self.myMap)
            var newCoordinate:CLLocationCoordinate2D = myMap.convertPoint(touchPoint, toCoordinateFromView: self.myMap)
            
            var loc = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) -> Void in
                if error != nil {
                    println("Error: \(error)")
                }
                else {
                    let p = CLPlacemark(placemark: placemarks[0] as CLPlacemark)
                    var subThoroughFare:String
                    var thoroughFare:String
                    
                    if p.subThoroughfare != nil {
                        subThoroughFare = p.subThoroughfare
                    }
                    else {
                        subThoroughFare = ""
                    }
                    
                    if p.thoroughfare != nil {
                        thoroughFare = p.thoroughfare
                    }
                    else {
                        thoroughFare = ""
                    }
                    
                    var title = "\(subThoroughFare) \(thoroughFare)"
                    
                    if title == " " {
                        var nsdate = NSDate()
                        var date = NSDate.dateByAddingTimeInterval(nsdate)
                        title = "added: \(date)"
                    }
                    
                    self.annotationY.coordinate = newCoordinate
                    self.annotationY.title = title
                    
                    places.append(["name":title, "lat": "\(newCoordinate.latitude)", "lon":"\(newCoordinate.longitude)"])
                }
            })
        
            myMap.addAnnotation(annotationY)
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
        annotationY.title = "You're Here!"
        
        myMap.addAnnotation(annotationY)
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("location error: \(error)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToPlaces" {
            self.navigationController?.navigationBarHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

