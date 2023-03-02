//
//  ViewModel.swift
//  EvenlyChallenge
//
//  Created by Zofia Drabek on 01.03.23.
//

import Foundation
import CoreLocation

class ViewModel {
        
    var search: Search
    var annotations: [String: POIAnnotation] = [:]
    var evenlyHQCoordinates: CLLocationCoordinate2D
    
    var updateAnnotations: (() -> Void)?
    var setCenter: ((CLLocationCoordinate2D) -> Void)?
    
    init(search: Search, evenlyHQCoordinates: CLLocationCoordinate2D) {
        self.search = search
        self.evenlyHQCoordinates = evenlyHQCoordinates
    }
    
    func viewDidLoad() {
        setCenter?(evenlyHQCoordinates)
        loadLoactions(for: evenlyHQCoordinates)
    }
    
    func centerUpdated(for location: CLLocationCoordinate2D) {
        loadLoactions(for: location)
    }
    
    private func loadLoactions(for location: CLLocationCoordinate2D) {
        search.loadLocations(location) { [weak self] results in
            guard let results, let self else { return }
            
            for result in results {
                guard let url = self.getURLFromID(result.fsqID) else { continue }
                self.annotations[result.fsqID] = POIAnnotation(title: result.name, coordinate: result.geocodes.main, link: url, id: result.fsqID)
            }
            DispatchQueue.main.async {
                self.updateAnnotations?()
            }
        }
    }
    
    private func getURLFromID(_ id: String) -> URL? {
        return URL(string: "https://foursquare.com/v/" + id)
    }
}
