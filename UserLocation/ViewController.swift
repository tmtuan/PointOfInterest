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
    var poilocations = [PointOfInterest]()
    
    var map: MKMapView = {
        let mv = MKMapView()
        mv.mapType = MKMapType.standard
        mv.showsCompass = true
        mv.showsScale = true
        mv.showsUserLocation = true
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()
    
    let currentLocationButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.setTitle("Current Location", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.addTarget(self, action: #selector(moveToCurrentLocation), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        view.backgroundColor = UIColor.purple
        view.addSubview(map)
        view.addSubview(currentLocationButton)
        
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
                        poilocations.append(PointOfInterest(description: (_location["description"] as? String)!, latitude: (_location["latitude"] as? String)!, longitude: (_location["longitude"] as? String)!))
                    }
                }
            }
        }
    }
    
    /* put locations from locations onto map*/
    func fillLocationIntoMap() {
        for location in poilocations {
            map.addAnnotation(location.getAnnotation())
        }
    }
    
    @objc func moveToCurrentLocation() {
        manager.startUpdatingLocation()
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
        manager.stopUpdatingLocation()
        
    }
    
    
    
    // MARK: Views
    func setupViews()
    {
        // Map
        map.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        map.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        map.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        map.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        // Current Location Button
        currentLocationButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        currentLocationButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        currentLocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        currentLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
   

}

