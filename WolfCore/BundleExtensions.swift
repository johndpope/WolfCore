//
//  BundleExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/15/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

// Similar to NSBundle.bundleForClass, except if aClass is nil (or omitted) the main bundle is returned

extension NSBundle {
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
