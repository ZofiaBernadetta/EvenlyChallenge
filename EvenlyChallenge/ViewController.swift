//
//  ViewController.swift
//  EvenlyChallenge
//
//  Created by Zofia Drabek on 28.02.23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    let viewModel: ViewModel
    let map = MKMapView()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        viewModel.updateAnnotations = updateAnnotationOnTheMap
        viewModel.setCenter = centerMap
        viewModel.viewDidLoad()
    }
    
    func setupMapView() {
        view.addSubview(map)
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        map.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: map.topAnchor),
            view.bottomAnchor.constraint(equalTo: map.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: map.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: map.trailingAnchor),
        ])
    }
    
    private func updateAnnotationOnTheMap() {
        for poiAnnotation in viewModel.annotations.map(\.value) {
            let contains = map.annotations.contains(where: { annotation in
                if let annotation = annotation as? POIAnnotation {
                    return annotation.id == poiAnnotation.id
                } else {
                    return false
                }
            })
            print(contains)
            if !contains {
                map.addAnnotation(poiAnnotation)
            }
        }
    }
    
    private func centerMap(coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(exactly: 500)!, longitudinalMeters: CLLocationDistance(exactly: 500)!)
        map.setRegion(region, animated: false)
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier") as? MKMarkerAnnotationView
        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "reuseIdentifier")
            view?.canShowCallout = true
            let btn = UIButton(frame: .init(origin: .zero, size: .init(width: 40, height: 40)))
            btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            view?.rightCalloutAccessoryView = btn
        } else {
            view?.annotation = annotation
        }
        view?.displayPriority = .required
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? POIAnnotation else { return }

        let firstActivityItem = annotation.link
           
        let activityViewController : UIActivityViewController = UIActivityViewController(
        activityItems: [firstActivityItem], applicationActivities: nil)
                      
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        viewModel.centerUpdated(for: mapView.centerCoordinate)
    }
    
}
