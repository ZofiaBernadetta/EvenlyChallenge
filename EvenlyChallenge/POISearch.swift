//
//  POISearch.swift
//  EvenlyChallenge
//
//  Created by Zofia Drabek on 28.02.23.
//

import Foundation
import CoreLocation

class POISearch: Search {
    let session = URLSession.shared
    let token = ""
    
    func loadLocations(_ location: CLLocationCoordinate2D, _ completion: @escaping ([PointOfInterest]?) -> Void) {
        let headers = [
          "accept": "application/json",
          "Authorization": token
        ]

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.foursquare.com"
        components.path = "/v3/places/nearby"
        components.percentEncodedQueryItems = [
            .init(name: "ll", value: "\(location.latitude),\(location.longitude)"),
            .init(name: "limit", value: "50")
        ]
        
        guard let url = components.url else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.allHTTPHeaderFields = headers

        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error -> Void in
            guard error == nil, (response as? HTTPURLResponse)?.statusCode == 200, let data else {
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            let responses = try? decoder.decode(Results.self, from: data)
            completion(responses?.results)
        }

        dataTask.resume()
    }
}

struct Results: Codable {
    let results: [PointOfInterest]
}

struct PointOfInterest: Codable {
    let fsqID: String
    let geocodes: Geocodes
    let name: String
    
    private enum CodingKeys : String, CodingKey {
        case fsqID = "fsq_id"
        case geocodes
        case name
    }
}

struct Geocodes: Codable {
    let main: Coordinates
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}
