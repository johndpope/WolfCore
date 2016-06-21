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

public func loadData(named name: String, withExtension anExtension: String? = nil, subdirectory subpath: String? = nil, fromBundleForClass aClass: AnyClass? = nil) throws -> Data {

    return try aClass |> Bundle.findBundle |> Bundle.urlForResource(name, withExtension: anExtension, subdirectory: subpath) |> URL.retrieveData
}

public func loadJSON(atURL url: URL) throws -> JSON.Value {
    return try url |> URL.retrieveData |> JSON.decode
}

public func loadJSON(named name: String, subdirectory subpath: String? = nil, fromBundleForClass aClass: AnyClass? = nil) throws -> JSON.Value {
    return try loadData(named: name, withExtension: "json", subdirectory: subpath, fromBundleForClass: aClass) |> JSON.decode
}

#if os(iOS) || os(tvOS)
public func loadStoryboard(named name: String, fromBundleForClass aClass: AnyClass? = nil) -> UIStoryboard {
    return UIStoryboard(name: name, bundle: Bundle.findBundle(forClass: aClass))
}

public func loadViewController<T: UIViewController>(withIdentifier identifier: String, fromStoryboardNamed storyboardName: String, fromBundleForClass aClass: AnyClass? = nil) -> T {
    let storyboard = loadStoryboard(named: storyboardName, fromBundleForClass: aClass)
    return storyboard.instantiateViewController(withIdentifier: identifier) as! T
}

public func loadInitialViewController<T: UIViewController>(fromStoryboardNamed storyboardName: String, fromBundleForClass aClass: AnyClass? = nil) -> T {
    let storyboard = loadStoryboard(named: storyboardName, fromBundleForClass: aClass)
    return storyboard.instantiateInitialViewController() as! T
}
#endif

public func loadNib(named name: String, fromBundleForClass aClass: AnyClass? = nil) -> OSNib {
    #if os(iOS) || os(tvOS)
        return UINib(nibName: name, bundle: Bundle.findBundle(forClass: aClass))
    #else
        return NSNib(nibNamed: name, bundle: Bundle.findBundle(forClass: aClass))!
    #endif
}

public func loadViewFromNib<T: OSView>(named name: String, fromBundleForClass aClass: AnyClass? = nil, owner: AnyObject? = nil) -> T {
    let nib = loadNib(named: name, fromBundleForClass: aClass)
    #if os(iOS) || os(tvOS)
        return nib.instantiate(withOwner: owner, options: nil)[0] as! T
    #else
        var objs: NSArray? = nil
        nib.instantiateWithOwner(owner, topLevelObjects: &objs)
        return objs![0] as! T
    #endif
}
