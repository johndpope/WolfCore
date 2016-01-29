//
//  ResourceUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/18/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public func loadDataNamed(name: String, withExtension anExtension: String? = nil, subdirectory subpath: String? = nil, fromBundleForClass aClass: AnyClass? = nil) throws -> NSData {
    
    if let data = NSData(contentsOfURL: NSBundle.findBundle(forClass: aClass).URLForResource(name, withExtension: anExtension, subdirectory: subpath)!) {
        return data
    } else {
        throw GeneralError(message: "Loading data failed.")
    }
}

public func loadJSONNamed(name: String, subdirectory subpath: String? = nil, fromBundleForClass aClass: AnyClass? = nil) throws -> JSONObject {
    let data = try loadDataNamed(name, withExtension: "json", subdirectory: subpath, fromBundleForClass: aClass)
    return try JSON.decode(data)
}

public func loadStoryboardNamed(name: String, fromBundleForClass aClass: AnyClass? = nil) -> UIStoryboard {
    return UIStoryboard(name: name, bundle: NSBundle.findBundle(forClass: aClass))
}

public func loadNibNamed(name: String, fromBundleForClass aClass: AnyClass? = nil) -> UINib {
    return UINib(nibName: name, bundle: NSBundle.findBundle(forClass: aClass))
}

public func loadViewFromNibNamed<T: UIView>(name: String, fromBundleForClass aClass: AnyClass? = nil, owner: AnyObject? = nil) -> T {
    let nib = loadNibNamed(name, fromBundleForClass: aClass)
    return nib.instantiateWithOwner(owner, options: nil)[0] as! T
}
