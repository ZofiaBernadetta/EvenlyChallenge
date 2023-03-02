//
//  Search.swift
//  EvenlyChallenge
//
//  Created by Zofia Drabek on 02.03.23.
//

import Foundation
import CoreLocation

protocol Search {
    func loadLocations(_ location: CLLocationCoordinate2D, _ completion: @escaping ([PointOfInterest]?) -> Void)
}
