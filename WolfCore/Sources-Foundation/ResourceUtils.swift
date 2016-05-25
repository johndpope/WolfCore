//
//  ResourceUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/18/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSStoryboard = UIStoryboard
    public typealias OSNib = UINib
#else
    import Cocoa
    public typealias OSStoryboard = NSStoryboard
    public typealias OSNib = NSNib
#endif

public func loadData(atURL url: NSURL) throws -> NSData {
    if let data = NSData(contentsOfURL: url) {
        return data
    } else {
        throw GeneralError(message: "Loading data failed: \(url).")
    }
}

public func loadData(named name: String, withExtension anExtension: String? = nil, subdirectory subpath: String? = nil, fromBundleForClass aClass: AnyClass? = nil) throws -> NSData {

    let url = NSBundle.findBundle(forClass: aClass).URLForResource(name, withExtension: anExtension, subdirectory: subpath)!
    return try loadData(atURL: url)
}

public func loadJSON(atURL url: NSURL) throws -> JSONObject {
    let data = try loadData(atURL: url)
    return try JSON.decode(data)
}

public func loadJSON(named name: String, subdirectory subpath: String? = nil, fromBundleForClass aClass: AnyClass? = nil) throws -> JSONObject {
    let data = try loadData(named: name, withExtension: "json", subdirectory: subpath, fromBundleForClass: aClass)
    return try JSON.decode(data)
}

#if os(iOS) || os(tvOS)
public func loadStoryboard(named name: String, fromBundleForClass aClass: AnyClass? = nil) -> UIStoryboard {
    return UIStoryboard(name: name, bundle: NSBundle.findBundle(forClass: aClass))
}

public func loadViewController<T: UIViewController>(withIdentifier identifier: String, fromStoryboardNamed storyboardName: String, fromBundleForClass aClass: AnyClass? = nil) -> T {
    let storyboard = loadStoryboard(named: storyboardName, fromBundleForClass: aClass)
    return storyboard.instantiateViewControllerWithIdentifier(identifier) as! T
}

public func loadInitialViewController<T: UIViewController>(fromStoryboardNamed storyboardName: String, fromBundleForClass aClass: AnyClass? = nil) -> T {
    let storyboard = loadStoryboard(named: storyboardName, fromBundleForClass: aClass)
    return storyboard.instantiateInitialViewController() as! T
}
#endif

public func loadNib(named name: String, fromBundleForClass aClass: AnyClass? = nil) -> OSNib {
    #if os(iOS) || os(tvOS)
        return UINib(nibName: name, bundle: NSBundle.findBundle(forClass: aClass))
    #else
        return NSNib(nibNamed: name, bundle: NSBundle.findBundle(forClass: aClass))!
    #endif
}

public func loadViewFromNib<T: OSView>(named name: String, fromBundleForClass aClass: AnyClass? = nil, owner: AnyObject? = nil) -> T {
    let nib = loadNib(named: name, fromBundleForClass: aClass)
    #if os(iOS) || os(tvOS)
        return nib.instantiateWithOwner(owner, options: nil)[0] as! T
    #else
        var objs: NSArray? = nil
        nib.instantiateWithOwner(owner, topLevelObjects: &objs)
        return objs![0] as! T
    #endif
}
