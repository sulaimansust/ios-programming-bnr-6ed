//
//  PointOfInterest.swift
//  WorldTrotter
//
//  Created by Laurent Boileau on 2017-05-15.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import Foundation
import MapKit

class PointOfInterest: NSObject, MKAnnotation {

    let latitude: Double
    let longitude: Double
    let annotationTitle: String

    init(latitude: Double, longitude: Double, title: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.annotationTitle = title
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var title: String? {
        return annotationTitle
    }

}
