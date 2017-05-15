//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Laurent Boileau on 2017-05-14.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var mapView: MKMapView!
    var locationManager: CLLocationManager?
    var pinIndex = 0

    let pointsOfInterest = [
        PointOfInterest(latitude: 45.4207054, longitude: -73.6248229, title: "LaSalle, Quebec"),
        PointOfInterest(latitude: 45.371725, longitude: -73.593310, title: "Saint-Constant, Quebec"),
        PointOfInterest(latitude: 49.228404, longitude: -123.006710, title: "Burnaby, British Columbia")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }

    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.delegate = self
        mapView.isRotateEnabled = false

        // Set it as *the* view of this view controller.
        view = mapView

        for poi in pointsOfInterest {
            mapView.addAnnotation(poi)
        }

        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)

        view.addSubview(segmentedControl)

        let locationButton = UIButton()
        locationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setTitle("Show Position", for: .normal)
        locationButton.setTitleColor(#colorLiteral(red: 1.458361749e-05, green: 0.4766390324, blue: 0.9993842244, alpha: 1), for: .normal)

        locationButton.addTarget(self, action: #selector(MapViewController.showPosition), for: .touchUpInside)

        view.addSubview(locationButton)

        let pinButton = UIButton()
        pinButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        pinButton.setTitle("Cycle Pins", for: .normal)
        pinButton.setTitleColor(#colorLiteral(red: 1.458361749e-05, green: 0.4766390324, blue: 0.9993842244, alpha: 1), for: .normal)

        pinButton.addTarget(self, action: #selector(MapViewController.cyclePins), for: .touchUpInside)

        view.addSubview(pinButton)

        let scTopConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let posTopConstraint = locationButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 3)
        let pinTopConstraint = pinButton.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 3)

        let margins = view.layoutMarginsGuide
        let scLeadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let scTrailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        let posLeadingConstraint = locationButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let posTrailingConstraint = locationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        let pinLeadingConstraint = pinButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let pinTrailingConstraint = pinButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)


        scTopConstraint.isActive = true
        posTopConstraint.isActive = true
        pinTopConstraint.isActive = true

        scLeadingConstraint.isActive = true
        scTrailingConstraint.isActive = true
        posLeadingConstraint.isActive = true
        posTrailingConstraint.isActive = true
        pinLeadingConstraint.isActive = true
        pinTrailingConstraint.isActive = true
    }

    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break;
        }
    }

    func showPosition() {
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .restricted, .denied:
            return
        default:
            break
        }

        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else if let location = locationManager?.location {
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan())
            mapView.setRegion(region, animated: true)
            return
        }

        if authStatus == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }

        if CLLocationManager.locationServicesEnabled() {
            if !mapView.isUserLocationVisible {
                mapView.showsUserLocation = true
            }
        }
    }

    func cyclePins() {
        pinIndex += 1
        if pinIndex == pointsOfInterest.count {
            pinIndex = 0
        }
        mapView.showAnnotations([pointsOfInterest[pinIndex]], animated: true)
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan())
        mapView.setRegion(region, animated: true)
    }
}
