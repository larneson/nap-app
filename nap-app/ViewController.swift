//
//  ViewController.swift
//  nap-app
//
//  Created by Link Arneson on 4/27/17.
//  Copyright © 2017 Link Arneson. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var currentBoundary = MKCircle()
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self 
        manager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse
        {
            manager.requestWhenInUseAuthorization()
            if let currentLocation = manager.location {
                centerMapOnLocation(location: currentLocation)
            }
        }
        

        manager.startUpdatingLocation()
        if let currentLocation = manager.location {
            centerMapOnLocation(location: currentLocation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var mapView: MKMapView!
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("lolfail", error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // most recent location update at the end of the array
        //let latestLocation = locations[locations.count - 1]
        // do something
        //print("this will never work :(")
    }

    @IBAction func selectButtonPressed(_ sender: Any) {
        print(mapView.centerCoordinate)
        mapView.remove(currentBoundary)
        currentBoundary = MKCircle(center: mapView.centerCoordinate, radius: regionRadius / 2)
        mapView.add(currentBoundary)
    }
}

