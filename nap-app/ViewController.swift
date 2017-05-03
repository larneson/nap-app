//
//  ViewController.swift
//  nap-app
//
//  Created by Link Arneson on 4/27/17.
//  Copyright © 2017 Link Arneson. All rights reserved.
//

import UIKit
import MapKit
protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let manager = CLLocationManager()
    //var currentBoundary = MKCircle()
    var resultSearchController:UISearchController? = nil
    var locationDisabled = false
    var selectedPin:MKPlacemark? = nil
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerPin: UIImageView!
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
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways
        {
            manager.requestAlwaysAuthorization()
            if let currentLocation = manager.location {
                centerMapOnLocation(location: currentLocation)
            }
        }
        

        manager.startUpdatingLocation()
        if let currentLocation = manager.location {
            centerMapOnLocation(location: currentLocation)
        } else {
            locationDisabled = true
        }
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locationDisabled {
            centerMapOnLocation(location: manager.location!)
            locationDisabled = false
        }
    }

    @IBAction func selectButtonPressed(_ sender: Any) {
        if locationDisabled {
            print("can't find location")
            return
        }
        print(mapView.userLocation)
        
        
        performSegue(withIdentifier: "toRadius", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            
            if id == "toRadius" {
                if let dest = segue.destination as? RadiusViewController{
                    //dest.centerCoordinate = mapView!.centerCoordinate
                    dest.region = mapView!.region
                    
                }
            }
            
        }
    }
    
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        if let location = placemark.location {
            centerMapOnLocation(location: location)
        }
    }
}

