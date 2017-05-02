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

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var slider: UISlider!
    @IBAction func sliderValueChanged(_ sender: Any) {
        let radius = Float(getRadiusDistance()/4)
        let newRadius = radius * slider.value * 2
        makeCircle(radius: CLLocationDistance(newRadius))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // center on center coordinate
        //let coordinateRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, regionRadius * 2.0, regionRadius * 2.0)
        //mapView.setRegion(coordinateRegion, animated: true)
        mapView.setRegion(region, animated: false)
        self.mapView.delegate = self
        makeCircle(radius: getRadiusDistance()/4)
        
        /*slider.maximumValueImage = #imageLiteral(resourceName: "Plus")
        slider.minimumValueImage = #imageLiteral(resourceName: "Minus")
        slider.maximumValue = 10
        slider.minimumValue = 1*/
    }
    
    func makeCircle(radius: CLLocationDistance) {
        self.mapView.removeOverlays(mapView.overlays)
        let currentBoundary = MKCircle(center: mapView.centerCoordinate, radius: radius)
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
