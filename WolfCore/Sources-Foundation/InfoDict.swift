//
//  InfoDict.swift
//  WolfCore
//
//  Created by Robert McNally on 5/21/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public let infoDict = InfoDict(bundle: NSBundle.mainBundle())

public class InfoDict {
    private let bundle: NSBundle

    public init(bundle: NSBundle) {
        self.bundle = bundle
    }

    public func object<T: AnyObject>(forKey key: String) -> T? {
        return bundle.objectForInfoDictionaryKey(key) as? T
    }

    public subscript(key: String) -> AnyObject? {
        return object(forKey: key)
    }

    public subscript(key: CFString) -> AnyObject? {
        return object(forKey: key as String)
    }

    public var bundleIdentifier: String {
        return self["CFBundleIdentifier"] as! String
    }

    public var version: String {
        return self["CFBundleShortVersionString"] as! String
    }

    public var build: String {
        return self[kCFBundleVersionKey] as! String
    }
}

extension NSBundle {
    public var infoDict: InfoDict {
        return InfoDict(bundle: self)
    }
}
