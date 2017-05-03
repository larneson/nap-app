//
//  FinalViewController.swift
//  nap-app
//
//  Created by Link Arneson on 5/2/17.
//  Copyright © 2017 Link Arneson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications
import AVFoundation

class FinalViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    var circle = MKCircle()
    var manager = CLLocationManager()
    var notificationDidFire = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        self.mapView.delegate = self
        self.mapView.add(circle)
        
        
        mapView.setRegion(regionBoundingEverything(), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    func regionBoundingEverything() -> MKCoordinateRegion {
        
        var minLat: CLLocationDegrees = 90.0
        var maxLat: CLLocationDegrees = -90.0
        var minLon: CLLocationDegrees = 180.0
        var maxLon: CLLocationDegrees = -180.0
        
        let radiusDegrees = circle.radius/6372797.6 * 90
        
        for x in [manager.location?.coordinate.longitude, circle.coordinate.longitude + radiusDegrees, circle.coordinate.longitude - radiusDegrees] {
            if let long = x {
                if (long < minLon) {
                    minLon = long
                }
                if (long > maxLon) {
                    maxLon = long
                }
            }
        }
        
        for y in [manager.location?.coordinate.latitude, circle.coordinate.latitude + radiusDegrees, circle.coordinate.latitude - radiusDegrees] {
            if let lat = y {
                if (lat < minLat) {
                    minLat = lat
                }
                if (lat > maxLat) {
                    maxLat = lat
                }
            }
        }
        
        let span = MKCoordinateSpanMake((maxLat - minLat) * 1.25, (maxLon - minLon) * 1.25)
        
        let center = CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2), maxLon - span.longitudeDelta / 2)
        
        return MKCoordinateRegionMake(center, span)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        mapView.setRegion(regionBoundingEverything(), animated: true)
        
        checkDistance()
    }
    
    func checkDistance() {
        if let loc = manager.location {
            if loc.distance(from: CLLocation(latitude: circle.coordinate.latitude, longitude: circle.coordinate.longitude)) <= circle.radius {
                performSingleNotification()
            }
        }
    }
    
    func performSingleNotification() {
        if notificationDidFire {
            return
        }
        
        AudioServicesPlayAlertSound(1005)
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
        localNotification.alertBody = "Time to wake up!"
        localNotification.alertAction = "Dismiss"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(localNotification)
        notificationDidFire = true
    }

}
