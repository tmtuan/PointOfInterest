//
//  ViewController.swift
//  UserLocation
//
//  Created by Tran Minh Tuan on 12/15/17.
//  Copyright © 2017 Tran Minh Tuan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    // MARK: properties
    var locations = [PointOfInterest]()
    
    var map: MKMapView = {
        let mv = MKMapView()
        mv.mapType = MKMapType.standard
        mv.showsCompass = true
        mv.showsScale = true
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        view.backgroundColor = UIColor.purple
        view.addSubview(map)
        
        manager.delegate = self
        manager.desiredAccuracy  = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    
        setupViews()
        fetchLocations()
        fillLocationIntoMap()
        
    }

    // MARK: methods
    /* get locations from CityLocation.plist */
    func fetchLocations() {
        if let path = Bundle.main.path(forResource: "CityLocation", ofType: "plist") {
            if let _locationList = NSArray(contentsOfFile: path) {
                for item in _locationList {
                    if let _location = item as? [String: Any] {
                        locations.append(PointOfInterest(description: (_location["description"] as? String)!, latitude: (_location["latitude"] as? String)!, longitude: (_location["longitude"] as? String)!))
                    }
                }
            }
        }
    }
    
    /* put locations from locations onto map*/
    func fillLocationIntoMap() {
        for location in locations {
            map.addAnnotation(location.getAnnotation())
        }
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = myLocation
        annotation.title = "MY CURRENT LOCATION"
        annotation.subtitle = "lat: \(annotation.coordinate.latitude) - long: \(annotation.coordinate.longitude)"
        map.addAnnotation(annotation)
        
    }
    
    
    
    // MARK: Views
    func setupViews()
    {
        map.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        map.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        map.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        map.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
   

}

