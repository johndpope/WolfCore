//
//  ResourceUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/18/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public func loadDataNamed(name: String, withExtension anExtension: String? = nil, fromBundleForClass aClass: AnyClass? = nil) -> NSData {
    return NSData(contentsOfURL: NSBundle.findBundle(forClass: aClass).URLForResource(name, withExtension: anExtension)!)!
}

public func loadJSONNamed(name: String, fromBundleForClass aClass: AnyClass? = nil) -> JSONObject {
    return loadDataNamed(name, withExtension: "json", fromBundleForClass: aClass).json!
}

public func loadStoryboardNamed(name: String, fromBundleForClass aClass: AnyClass? = nil) -> UIStoryboard {
    return UIStoryboard(name: name, bundle: NSBundle.findBundle(forClass: aClass))
}

public func loadNibNamed(name: String, fromBundleForClass aClass: AnyClass? = nil) -> UINib {
    return UINib(nibName: name, bundle: NSBundle.findBundle(forClass: aClass))
}
