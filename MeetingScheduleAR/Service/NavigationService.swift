//
//  NavigationService.swift
//  MeetingScheduleAR
//
//  Created by ernie.cheng on 10/12/17.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//

import MapKit
import CoreLocation

struct NavigationService {
    
    func getDirections(destinationLocaiton: CLLocationCoordinate2D,
                       request: MKDirectionsRequest,
                       completion: @escaping([MKRouteStep]) -> Void) {
        var steps: [MKRouteStep] = []
        
        let placeMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLocaiton.latitude,
                                                                       longitude: destinationLocaiton.longitude))
        
        request.destination = MKMapItem(placemark: placeMark)
        request.source = MKMapItem.forCurrentLocation()
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if error != nil {
                print("Error getting directions")
            } else {
                guard let response = response else {return}
                for route in response.routes {
                    steps.append(contentsOf: route.steps)
                }
                completion(steps)
            }
        }
    }
}
