//
//  DeviceUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 4/19/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public let isPad: Bool = {
    return UIDevice.current().userInterfaceIdiom == .pad
}()

public let isPhone: Bool = {
    return UIDevice.current().userInterfaceIdiom == .phone
}()

public let isTV: Bool = {
    return UIDevice.current().userInterfaceIdiom == .TV
}()

public let isCarPlay: Bool = {
    return UIDevice.current().userInterfaceIdiom == .carPlay
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
    var systemInfo = Bytes(repeating: 0, count: sizeof(utsname))

    let model = systemInfo.withUnsafeMutableBufferPointer { (body: inout UnsafeMutableBufferPointer<Byte>) -> String? in
        guard uname(UnsafeMutablePointer(body.baseAddress)) == 0 else { return nil }
        return String(cString: UnsafePointer(body.baseAddress!.advanced(by: Int(_SYS_NAMELEN * 4))))
    }

    return model
}

public var defaultTintColor: UIColor = {
    return UIView().tintColor!
}()
