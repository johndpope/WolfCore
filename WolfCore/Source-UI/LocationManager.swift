//
//  LocationManager.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/17/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation
import CoreLocation

public class LocationManager: CLLocationManager {
    public override init() {
        super.init()
        delegate = self
    }

    public var didUpdateLocations: (([CLLocation]) -> Void)?
    public var didFail: ErrorBlock?
    public var didFailDeferredUpdates: ErrorBlock?
    public var didFinishDeferredUpdates: Block?
    public var didUpdateTo: ((_ to: CLLocation, _ from: CLLocation) -> Void)?
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
        didUpdateLocations?(locations)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logError(error)
        didFail?(error)
    }

    public func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        guard let error = error else {
            didFinishDeferredUpdates?()
            return
        }
        logError(error)
        didFailDeferredUpdates?(error)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        didUpdateHeading?(newHeading)
    }

    public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return shouldDisplayHeadingCalibration?() ?? true
    }

    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        didDetermineStateForRegion?(state, region)
    }

    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        didRangeBeacons?(beacons, region)
    }

    public func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        rangingBeaconsFailedInRegion?(region, error)
    }

    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        didEnterRegion?(region)
    }

    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        didExitRegion?(region)
    }

    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        monitoringFailedForRegion?(region, error)
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        didChangeAuthorizationStatus?(status)
    }

    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        didStartMonitoringForRegion?(region)
    }

    public func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        didPauseLocationUpdates?()
    }

    public func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        didResumeLocationUpdates?()
    }

    public func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        didVisit?(visit)
    }
}
