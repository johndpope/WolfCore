//
//  LocationManager.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/17/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation
import CoreLocation

extension Log.GroupName {
    public static let location = Log.GroupName("location")
}

public class LocationManager: CLLocationManager {
    public override init() {
        super.init()
        delegate = self
    }

    public var didUpdateLocations: (([CLLocation]) -> Void)?
    public var didFail: ErrorBlock?
    public var didFailDeferredUpdates: ErrorBlock?
    public var didFinishDeferredUpdates: Block?
    public var didUpdateHeading: ((CLHeading) -> Void)?
    public var shouldDisplayHeadingCalibration: (() -> Bool)?
    public var didDetermineStateForRegion: ((_ state: CLRegionState, _ region: CLRegion) -> Void)?
    public var didRangeBeacons: ((_ beacons: [CLBeacon], _ region: CLBeaconRegion) -> Void)?
    public var rangingBeaconsFailedInRegion: ((CLBeaconRegion, Error) -> Void)?
    public var didEnterRegion: ((CLRegion) -> Void)?
    public var didExitRegion: ((CLRegion) -> Void)?
    public var monitoringFailedForRegion: ((CLRegion?, Error) -> Void)?
    public var didChangeAuthorizationStatus: ((CLAuthorizationStatus) -> Void)?
    public var didStartMonitoringForRegion: ((CLRegion) -> Void)?
    public var didPauseLocationUpdates: Block?
    public var didResumeLocationUpdates: Block?
    public var didVisit: ((CLVisit) -> Void)?
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        logTrace("didUpdateLocations", group: .location)
        didUpdateLocations?(locations)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logTrace("didFail", group: .location)
        logError(error)
        if let error = error as? CLError {
            if error.code == .locationUnknown && isSimulator {
                logWarning("You are running in the simulator without a location set in the scheme.")
            }
        }
        didFail?(error)
    }

    public func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        guard let error = error else {
            logTrace("didFinishDeferredUpdates", group: .location)
            didFinishDeferredUpdates?()
            return
        }
        logTrace("didFailDeferredUpdates", group: .location)
        logError(error)
        didFailDeferredUpdates?(error)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        logTrace("didUpdateHeading", group: .location)
        didUpdateHeading?(newHeading)
    }

    public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        logTrace("shouldDisplayHeadingCalibration", group:. location)
        return shouldDisplayHeadingCalibration?() ?? true
    }

    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        logTrace("didDetermineStateForRegion", group:. location)
        didDetermineStateForRegion?(state, region)
    }

    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        logTrace("didRangeBeacons", group:. location)
        didRangeBeacons?(beacons, region)
    }

    public func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        logTrace("rangingBeaconsFailedInRegion", group:. location)
        rangingBeaconsFailedInRegion?(region, error)
    }

    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        logTrace("didEnterRegion", group:. location)
        didEnterRegion?(region)
    }

    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        logTrace("didExitRegion", group:. location)
        didExitRegion?(region)
    }

    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        logTrace("monitoringFailedForRegion", group:. location)
        monitoringFailedForRegion?(region, error)
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        logTrace("didChangeAuthorizationStatus: \(status)", group:. location)
        didChangeAuthorizationStatus?(status)
    }

    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        logTrace("didStartMonitoringForRegion", group:. location)
        didStartMonitoringForRegion?(region)
    }

    public func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        logTrace("didPauseLocationUpdates", group:. location)
        didPauseLocationUpdates?()
    }

    public func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        logTrace("didResumeLocationUpdates", group:. location)
        didResumeLocationUpdates?()
    }

    public func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        logTrace("didVisit", group:. location)
        didVisit?(visit)
    }
}

extension CLAuthorizationStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notDetermined:
            return ".notDetermined"
        case .denied:
            return ".denied"
        case .restricted:
            return ".restricted"
        case .authorizedAlways:
            return ".authorizedAlways"
        case .authorizedWhenInUse:
            return ".authorizedWhenInUse"
        }
    }
}
