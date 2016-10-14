//
//  ViewController.swift
//  RUSH01
//
//  Created by Fabien TAFFOREAU on 10/14/16.
//  Copyright © 2016 Fabien TAFFOREAU. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    var searchAnnotation : MKPointAnnotation! {
        didSet {
            self.mapView.removeAnnotations(mapView.annotations)
            self.mapView.showAnnotations([searchAnnotation], animated: true )
            let region = MKCoordinateRegion(center: searchAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }

    var searchItem: MKMapItem! {
        didSet {
            let tmp = MKPointAnnotation()
            if let location = searchItem.placemark.location {
                tmp.coordinate = location.coordinate
                tmp.title = searchItem.name
                searchAnnotation = tmp
            }
        }
    }
    
    var itinary: (MKMapItem, MKMapItem)! {
        didSet {
            print(itinary)
            self.mapView.removeOverlays(self.mapView.overlays)
            createItinary()
        }
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }

    @IBAction func ChangeMap(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            self.mapView.mapType = MKMapType.Standard
            break
        case 1:
            self.mapView.mapType =  MKMapType.Satellite
            break
        case 2:
            self.mapView.mapType = MKMapType.Hybrid
            break
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "searchSegue" {
            if let vc = segue.destinationViewController as? ResultsTableViewController {
                vc.regionMap = self.mapView.region
            }
        } else if segue.identifier == "itinarySegue" {
            if let vc = segue.destinationViewController as? ItinaryViewController {
                vc.regionMap = self.mapView.region
            }
        }
    }
    
    //TO DISPLAY ROUTE LINE
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        print(overlay.title)
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func createItinary() {
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = itinary.0
        directionRequest.destination = itinary.1
        directionRequest.transportType = .Automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculateDirectionsWithCompletionHandler {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    //UNWINSEGUE
    @IBAction func unWindSegue(segue : UIStoryboardSegue) {
        return
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    

/*
        
    
        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .Automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculateDirectionsWithCompletionHandler {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    
    
    */
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

