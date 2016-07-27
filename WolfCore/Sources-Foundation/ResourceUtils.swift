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

public func loadData(named name: String, withExtension anExtension: String? = nil, subdirectory subpath: String? = nil, in bundle: Bundle? = nil) throws -> Data {
    let bundle = bundle ?? Bundle.main
    return try bundle |> Bundle.urlForResource(name, withExtension: anExtension, subdirectory: subpath) |> URL.retrieveData
}

public func loadJSON(atURL url: URL) throws -> JSON {
    return try url |> URL.retrieveData |> JSON.init
}

public func loadJSON(named name: String, subdirectory subpath: String? = nil, in bundle: Bundle? = nil) throws -> JSON {
    return try loadData(named: name, withExtension: "json", subdirectory: subpath, in: bundle) |> JSON.init
}

#if os(iOS) || os(tvOS)
public func loadStoryboard(named name: String, in bundle: Bundle? = nil) -> UIStoryboard {
    let bundle = bundle ?? Bundle.main
    return UIStoryboard(name: name, bundle: bundle)
}

public func loadViewController<T: UIViewController>(withIdentifier identifier: String, fromStoryboardNamed storyboardName: String, in bundle: Bundle? = nil) -> T {
    let storyboard = loadStoryboard(named: storyboardName, in: bundle)
    return storyboard.instantiateViewController(withIdentifier: identifier) as! T
}

public func loadInitialViewController<T: UIViewController>(fromStoryboardNamed storyboardName: String, in bundle: Bundle? = nil) -> T {
    let storyboard = loadStoryboard(named: storyboardName, in: bundle)
    return storyboard.instantiateInitialViewController() as! T
}
#endif

public func loadNib(named name: String, in bundle: Bundle? = nil) -> OSNib {
    let bundle = bundle ?? Bundle.main
    #if os(iOS) || os(tvOS)
        return UINib(nibName: name, bundle: bundle)
    #else
        return NSNib(nibNamed: name, bundle: bundle)!
    #endif
}

public func loadViewFromNib<T: OSView>(named name: String, in bundle: Bundle? = nil, owner: AnyObject? = nil) -> T {
    let nib = loadNib(named: name, in: bundle)
    #if os(iOS) || os(tvOS)
        return nib.instantiate(withOwner: owner, options: nil)[0] as! T
    #else
        var objs: NSArray? = nil
        nib.instantiateWithOwner(owner, topLevelObjects: &objs)
        return objs![0] as! T
    #endif
}
