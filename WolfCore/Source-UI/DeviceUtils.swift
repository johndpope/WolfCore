//
//  DeviceUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 4/19/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public let isPad: Bool = {
    return UIDevice.currentDevice().userInterfaceIdiom == .Pad
}()

public let isPhone: Bool = {
    return UIDevice.currentDevice().userInterfaceIdiom == .Phone
}()

public let isTV: Bool = {
    return UIDevice.currentDevice().userInterfaceIdiom == .TV
}()

public let isCarPlay: Bool = {
    return UIDevice.currentDevice().userInterfaceIdiom == .CarPlay
}()

#if arch(i386) || arch(x86_64)
    public let isSimulator = true
#else
    public let isSimulator = false
#endif

public var osVersion: String {
    let os = NSProcessInfo().operatingSystemVersion
    return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
}

public var deviceModel: String? {
    var systemInfo = [UInt8](count: sizeof(utsname), repeatedValue: 0)
    
    let model = systemInfo.withUnsafeMutableBufferPointer { (inout body: UnsafeMutableBufferPointer<UInt8>) -> String? in
        if uname(UnsafeMutablePointer(body.baseAddress)) != 0 {
            return nil
        }
        return String.fromCString(UnsafePointer(body.baseAddress.advancedBy(Int(_SYS_NAMELEN * 4))))
    }
    
    return model
}
