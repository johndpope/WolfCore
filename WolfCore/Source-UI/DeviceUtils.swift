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
