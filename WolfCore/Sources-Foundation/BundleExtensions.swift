//
//  BundleExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/15/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

/// WolfCore.BundleClass.self can be used as an argument to the NSBundle.findBundle(forClass:) method to search within this framework bundle.
public class BundleClass { }

extension NSBundle {
    /// Similar to NSBundle.bundleForClass, except if aClass is nil (or omitted) the main bundle is returned
    public static func findBundle(forClass aClass: AnyClass? = nil) -> NSBundle {
        let bundle: NSBundle
        if let aClass = aClass {
            bundle = NSBundle(forClass: aClass)
        } else {
            bundle = NSBundle.mainBundle()
        }
        return bundle
    }
}
