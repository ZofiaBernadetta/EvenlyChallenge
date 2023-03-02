//
//  POIAnnotation.swift
//  EvenlyChallenge
//
//  Created by Zofia Drabek on 01.03.23.
//

import Foundation
import MapKit

class POIAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var link: URL
    var id: String

    init(title: String, coordinate: Coordinates, link: URL, id: String) {
        self.title = title
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.link = link
        self.id = id
    }
}
