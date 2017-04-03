//
//  DeviceAccess.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/23/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import CoreLocation

public struct DeviceAccess {

    public enum Item: String {
        case camera
        case photoLibrary
        case location

        private typealias `Self` = Item

        private static let messages: [Item: String] = [
            .camera : "Please allow #{appName} to access the camera.",
            .photoLibrary : "Please allow #{appName} to access your photo library.",
            .location : "Please allow #{appName} to access location."
        ]

        private static let usageDescriptionKeys: [Item: String] = [
            .camera : "NSCameraUsageDescription",
            .photoLibrary: "NSPhotoLibraryUsageDescription",
            .location: "NSLocationAlwaysUsageDescription"
        ]

        public var message: String {
            return Self.messages[self]! ¶ ["appName": appInfo.appName]
        }

        public var usageDescriptionKey: String {
            return Self.usageDescriptionKeys[self]!
        }

        public var hasUsageDescription: Bool {
            return appInfo.hasKey(key: usageDescriptionKey)
        }

        public func checkUsageDescription() {
            guard hasUsageDescription else {
                fatalError("No Info.plist usage description for: \(usageDescriptionKey).")
            }
        }
    }

    public static func checkCameraAuthorized(from viewController: UIViewController) -> Bool {
        Item.camera.checkUsageDescription()

        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
        case .authorized, .notDetermined:
            return true
        case .denied, .restricted:
            viewController.presentAccessSheet(for: .camera)
            return false
        }
    }

    public static func checkPhotoLibraryAuthorized(from viewController: UIViewController) -> Bool {
        Item.photoLibrary.checkUsageDescription()

        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .notDetermined:
            return true
        case .denied, .restricted:
            viewController.presentAccessSheet(for: .photoLibrary)
            return false
        }
    }
    
    public static func checkLocationAuthorized(from viewController: UIViewController) -> Bool {
        Item.location.checkUsageDescription()
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorized, .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            return true
        case .denied, .restricted:
            viewController.presentAccessSheet(for: .location)
            return false
        }
    }
}

extension UIViewController {
    public func presentAccessSheet(for accessItem: DeviceAccess.Item, popoverSourceView: UIView? = nil, popoverSourceRect: CGRect? = nil, popoverBarButtonItem: UIBarButtonItem? = nil, popoverPermittedArrowDirections: UIPopoverArrowDirection = .any, didAppear: Block? = nil, didDisappear: Block? = nil) {
        let openSettingsAction = AlertAction(title: "Open Settings"¶, style: .default, identifier: "openSettings") { _ in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        let actions = [
            openSettingsAction,
            AlertAction.newCancelAction()
        ]
        presentSheet(withTitle: accessItem.message, identifier: "access", popoverSourceView: popoverSourceView, popoverSourceRect: popoverSourceRect, popoverBarButtonItem: popoverBarButtonItem, popoverPermittedArrowDirections: popoverPermittedArrowDirections, actions: actions, didAppear: didAppear, didDisappear: didDisappear)
    }
}
