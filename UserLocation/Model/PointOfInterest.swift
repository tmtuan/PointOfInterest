//
//  PointOfInterest.swift
//  UserLocation
//
//  Created by Tran Minh Tuan on 12/16/17.
//  Copyright © 2017 Tran Minh Tuan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PointOfInterest: NSObject {
    
    var desc: String
    var lat: String
    var long: String
    
    init(description: String, latitude: String, longitude: String) {
        desc = description
        lat = latitude
        long = longitude
    }
    
    func getAnnotation() -> MKPointAnnotation {
        let latitude: CLLocationDegrees = Double(lat)!
        let longitude: CLLocationDegrees = Double(long)!
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = desc
        return annotation
    }
}
