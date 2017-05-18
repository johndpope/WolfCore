//
//  LocationMonitor.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/18/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit
import CoreLocation

public class LocationMonitor {
    private let locationManager: LocationManager
    public private(set) var recentLocations = [CLLocation]()
    private var isStarted: Bool = false

    public var location: CLLocation? {
        return locationManager.location
    }

    public init(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyKilometer, distanceFilter: CLLocationDistance = kCLDistanceFilterNone) {
        locationManager = LocationManager()
        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.distanceFilter = distanceFilter
    }

    public func start(with viewController: UIViewController) {
        guard !isStarted else { return }

        isStarted = true

        guard DeviceAccess.checkLocationWhenInUseAuthorized(from: viewController) else {
            logWarning("Unable to start monitoring location.", group: .location)
            return
        }

        locationManager.didChangeAuthorizationStatus = { [unowned self] status in
            switch status {
            case .notDetermined:
                break
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.startUpdatingLocation()
            case .denied, .restricted:
                break
            }
        }

        locationManager.didUpdateLocations = { [unowned self] locations in
            self.recentLocations = locations
            logTrace(locations)
        }

        locationManager.requestWhenInUseAuthorization()
    }
}
