//
//  MemoryCacheLayer.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public class MemoryCacheLayer: CacheLayer {

    private let cache = NSCache<NSURL, NSData>()

    public init() {
        logTrace("init", obj: self, group: .cache)
    }

    public func store(data: Data, forURL url: URL) {
        logTrace("storeData forURL: \(url)", obj: self, group: .cache)
        cache.setObject(data as NSData, forKey: url as NSURL)
    }

    public func retrieveData(forURL url: URL, completion: @escaping CacheLayerCompletion) {
        logTrace("retrieveDataForURL: \(url)", obj: self, group: .cache)
        let data = cache.object(forKey: url as NSURL) as Data?
        completion(data)
    }

    public func removeData(forURL url: URL) {
        logTrace("removeDataForURL: \(url)", obj: self, group: .cache)
        cache.removeObject(forKey: url as NSURL)
    }

    public func removeAll() {
        logTrace("removeAll", obj: self, group: .cache)
        cache.removeAllObjects()
    }
}
