//
//  EvenlyChallengeTests.swift
//  EvenlyChallengeTests
//
//  Created by Zofia Drabek on 28.02.23.
//

import XCTest
@testable import EvenlyChallenge
import CoreLocation

final class ViewModelTests: XCTestCase {
    
    let viewModel = ViewModel(search: MockSearch(), evenlyHQCoordinates: CLLocationCoordinate2D(latitude: 52.500342, longitude: 13.425170))
    
    var pois1 = [
        PointOfInterest(fsqID: "1", geocodes: Geocodes(main: Coordinates(latitude: 12.3, longitude: 12.3)), name: "First"),
        PointOfInterest(fsqID: "2", geocodes: Geocodes(main: Coordinates(latitude: 22.3, longitude: 22.3)), name: "Second")
    ]
    
    var pois2 = [
        PointOfInterest(fsqID: "3", geocodes: Geocodes(main: Coordinates(latitude: 32.3, longitude: 32.3)), name: "Third"),
        PointOfInterest(fsqID: "2", geocodes: Geocodes(main: Coordinates(latitude: 22.3, longitude: 22.3)), name: "Second")
    ]

    func testViewDidLoad() {
        let expectation1 = XCTestExpectation(description: "setCenter called")
        viewModel.setCenter = { _ in
            expectation1.fulfill()
        }
        viewModel.search = MockSearch(currentPois: pois1)
        viewModel.viewDidLoad()
        viewModel.search = MockSearch(currentPois: pois2)
        viewModel.viewDidLoad()
        
        wait(for: [expectation1], timeout: 0.1)
        XCTAssertEqual(viewModel.annotations.count, 3)
    }
}
