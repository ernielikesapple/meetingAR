//
//  LocationService.swift
//  MeetingScheduleAR
//
//  Created by ernie.cheng on 10/13/17.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class{
    func trackingLocation(for currentLocation: CLLocation)
    func trackingLocationDidFail(with error: Error)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var delegate: LocationServiceDelegate?
    var currentLocation: CLLocation?
    var lastLocation: CLLocation?
    var initial: Bool = true
    var userHeading: CLLocationDirection!
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
    }
    
    func requestAuthorization(locationManager: CLLocationManager) {
        locationManager.requestWhenInUseAuthorization()
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation(locationManager: locationManager)
        case .denied, .notDetermined, .restricted:
            stopUpdatingLocation(locationManager: locationManager)
        }
    }
    
    func startUpdatingLocation(locationManager: CLLocationManager) {
        locationManager.startUpdatingLocation() // location
        locationManager.startUpdatingHeading() // direction
    }
    
    func stopUpdatingLocation(locationManager: CLLocationManager) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    
    
    
    
    
}
