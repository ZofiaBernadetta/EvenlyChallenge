//
//  MockSearch.swift
//  EvenlyChallengeTests
//
//  Created by Zofia Drabek on 02.03.23.
//

import Foundation
@testable import EvenlyChallenge
import CoreLocation

class MockSearch: Search {
    
    var currentPois: [PointOfInterest]?

    internal init(currentPois: [PointOfInterest]? = nil) {
        self.currentPois = currentPois
    }
    
    func loadLocations(_ location: CLLocationCoordinate2D, _ completion: @escaping ([EvenlyChallenge.PointOfInterest]?) -> Void) {
        completion(currentPois)
    }
}
