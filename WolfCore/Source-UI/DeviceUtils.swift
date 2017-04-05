//
//  DeviceUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/19/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import CoreGraphics
#endif

#if os(iOS) || os(tvOS)
public let isPad: Bool = {
    return UIDevice.current.userInterfaceIdiom == .pad
}()

public let isPhone: Bool = {
    return UIDevice.current.userInterfaceIdiom == .phone
}()

public let isTV: Bool = {
    return UIDevice.current.userInterfaceIdiom == .tv
}()

public let isCarPlay: Bool = {
    return UIDevice.current.userInterfaceIdiom == .carPlay
}()

#if arch(i386) || arch(x86_64)
    public let isSimulator = true
#else
    public let isSimulator = false
#endif

public var osVersion: String {
    let os = ProcessInfo().operatingSystemVersion
    return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
}

public var deviceModel: String? {
    let utsSize = MemoryLayout<utsname>.size
    var systemInfo = Data(capacity: utsSize)

    let model: String? = systemInfo.withUnsafeMutableBytes { (uts: UnsafeMutablePointer<utsname>) in
        guard uname(uts) == 0 else { return nil }
        return uts.withMemoryRebound(to: CChar.self, capacity: utsSize) { String(cString: $0) }
    }

    return model
}

public var deviceName: String {
    #if os(iOS)
        return UIDevice.current.name
    #else
        return Host.current().localizedName ?? ""
    #endif
}

public var defaultTintColor: UIColor = {
    return UIView().tintColor!
}()

extension UIInterfaceOrientationMask: CustomStringConvertible {
    public var description: String {
        let joiner = Joiner(left: "[", separator: ",", right: "]")
        if self.contains(.portrait) {
            joiner.append("portrait")
        }
        if self.contains(.landscapeLeft) {
            joiner.append("landscapeLeft")
        }
        if self.contains(.landscapeRight) {
            joiner.append("landscapeRight")
        }
        if self.contains(.portraitUpsideDown) {
            joiner.append("portraitUpsideDown")
        }
        return joiner.description
    }
}

extension UIDeviceOrientation: CustomStringConvertible {
    public var description: String {
        let s: String
        switch self {
        case .unknown:
            s = "unknown"
        case .portrait:
            s = "portrait"
        case .portraitUpsideDown:
            s = "portraitUpsideDown"
        case .landscapeLeft:
            s = "landscapeLeft"
        case .landscapeRight:
            s = "landscapeRight"
        case .faceUp:
            s = "faceUp"
        case .faceDown:
            s = "faceDown"
        }
        return "[\(s)]"
    }
}

extension UIDevice {
    public func force(toOrientation orientation: UIInterfaceOrientation) {
        setValue(orientation.rawValue, forKey: "orientation")
    }

    public static var currentOrientation: UIDeviceOrientation {
        let device = UIDevice.current
        device.beginGeneratingDeviceOrientationNotifications()
        defer { device.endGeneratingDeviceOrientationNotifications() }
        return device.orientation
    }
}

public func forcePhoneToPortraitOrientation() {
    if isPhone {
        UIDevice.current.force(toOrientation: UIInterfaceOrientation.portrait)
    }
}

public func forceToPortraitOrientation() {
    UIDevice.current.force(toOrientation: UIInterfaceOrientation.portrait)
}
#endif

public var mainScreenScale: CGFloat {
    #if os(iOS) || os(tvOS)
        return UIScreen.main.scale
    #else
        return 1.0
    #endif
}
