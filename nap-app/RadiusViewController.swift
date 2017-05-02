//
//  RadiusViewController.swift
//  nap-app
//
//  Created by Link Arneson on 5/1/17.
//  Copyright © 2017 Link Arneson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RadiusViewController: UIViewController, MKMapViewDelegate {
    
    //var centerCoordinate = CLLocationCoordinate2D()
    //let regionRadius: CLLocationDistance = 1000
    var region = MKCoordinateRegion()
    var currentBoundary = MKCircle()

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var slider: UISlider!
    @IBAction func sliderValueChanged(_ sender: Any) {
        let radius = Float(getRadiusDistance()/4)
        let newRadius = radius * slider.value * 2
        makeCircle(radius: CLLocationDistance(newRadius))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setRegion(region, animated: false)
        self.mapView.delegate = self
        makeCircle(radius: getRadiusDistance()/4)
    }
    
    func makeCircle(radius: CLLocationDistance) {
        self.mapView.removeOverlays(self.mapView.overlays)
        currentBoundary = MKCircle(center: mapView.centerCoordinate, radius: radius)
        self.mapView.add(currentBoundary)


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
    
    func getRadiusDistance() -> CLLocationDistance {
        let mRect: MKMapRect = self.mapView.visibleMapRect
        let eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect))
        let westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect))
        let currentDistWideInMeters = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint)
        return currentDistWideInMeters as CLLocationDistance
    }

    @IBAction func setRadiusPressed(_ sender: Any) {
        performSegue(withIdentifier: "toFinal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "toFinal" {
                if let dest = segue.destination as? FinalViewController {
                    dest.circle = currentBoundary
                }
            }
        }
    }

}
