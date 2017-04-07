//
//  Cache.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation
import CoreGraphics

extension Log.GroupName {
    public static let cache = Log.GroupName("cache")
}

public class Cache<T: Serializable> {
    public typealias SerializableType = T
    public typealias ValueType = T.ValueType
    public typealias Completion = (ValueType?) -> Void

    private let layers: [CacheLayer]

    public init(layers: [CacheLayer]) {
        self.layers = layers
    }

    public convenience init(filename: String, sizeLimit: Int, includeHTTP: Bool) {

        #if !os(tvOS)
            var layers: [CacheLayer] = [
                MemoryCacheLayer(),
                LocalStorageCacheLayer(filename: filename, sizeLimit: sizeLimit)!,
                ]
        #else
            var layers: [CacheLayer] = [
                MemoryCacheLayer()
            ]
        #endif
        if includeHTTP {
            layers.append(HTTPCacheLayer())
        }
        self.init(layers: layers)
    }

    public func storeObject(obj: SerializableType, forURL url: URL, withSize size: CGSize) {
        let scale = mainScreenScale

        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "fit", value: "max"),
            URLQueryItem(name: "w", value: "\(Int(size.width * scale))"),
            URLQueryItem(name: "h", value: "\(Int(size.height * scale))"),
        ]
        if let url: URL = urlComponents?.url {
            logInfo("storeObject obj: \(obj), forURL: \(url)", obj: self, group: .cache)
            let data = obj.serialize()
            for layer in layers {
                layer.store(data: data, forURL: url)
            }
        } else {
            logError("storeObject obj: \(obj), forURL: \(url)", obj: self, group: .cache)
        }
    }

    public func store(obj: SerializableType, forURL url: URL) {
        logInfo("storeObject obj: \(obj), forURL: \(url)", obj: self, group: .cache)
        let data = obj.serialize()
        for layer in layers {
            layer.store(data: data, forURL: url)
        }
    }

    @discardableResult public func retrieveObject(forURL url: URL, withSize size: CGSize, completion: @escaping Completion) -> Cancelable? {
        let scale = mainScreenScale

        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "fit", value: "max"),
            URLQueryItem(name: "w", value: "\(Int(size.width * scale))"),
            URLQueryItem(name: "h", value: "\(Int(size.height * scale))"),
        ]
        if let url: URL = urlComponents?.url {
            return retrieveObject(forURL: url, completion: completion)
        } else {
            logError("retrieveObjectForURL: \((urlComponents?.url)†)", obj: self, group: .cache)
            completion(nil)
            return nil
        }
    }

    @discardableResult public func retrieveObject(forURL url: URL, completion: @escaping Completion) -> Cancelable? {
        logInfo("retrieveObjectForURL: \(url)", obj: self, group: .cache)
        let canceler = Canceler()
        layers[0].retrieveData(forURL: url, completion: retrieveLayerCompletion(forIndex: 0, url: url, completion: { value in
            guard !canceler.isCanceled else { return }
            completion(value)
        }))
        return canceler
    }

    public func removeObject(forURL url: URL) {
        logInfo("removeObjectForURL: \(url)", obj: self, group: .cache)
        for layer in layers {
            layer.removeData(forURL: url)
        }
    }

    public func removeAll() {
        logInfo("removeAll", obj: self, group: .cache)
        for layer in layers {
            layer.removeAll()
        }
    }

    private func retrieveLayerCompletion(forIndex layerIndex: Int, url: URL, completion: @escaping Completion) -> (Data?) -> Void {
        return { data in
            let layer = self.layers[layerIndex]
            guard let data = data else {
                logInfo("Data not found for URL: \(url) layer: \(layer)", obj: self, group: .cache)
                if layerIndex < self.layers.count - 1 {
                    let nextIndex = layerIndex + 1
                    self.layers[nextIndex].retrieveData(forURL: url, completion: self.retrieveLayerCompletion(forIndex: nextIndex, url: url, completion: completion))
                } else {
                    completion(nil)
                }
                return
            }

            do {
                let obj: ValueType = try SerializableType.deserialize(from: data)
                logInfo("Found object for URL: \(url) layer: \(layer)", obj: self, group: .cache)
                // If we found the data and successfully deserialized it, then store it in all the layers above this one
                for i in 0 ..< layerIndex {
                    self.layers[i].store(data: data, forURL: url)
                }
                completion(obj)
            } catch let error {
                logError("Could not deserialize data for URL: \(url) layer: \(layer) error: \(error)", obj: self)
                // If the data can't be deserialized then it's corrupt, so remove it from this layer and all the layers beneath it
                for i in layerIndex ..< self.layers.count {
                    self.layers[i].removeData(forURL: url)
                }
                completion(nil)
                return
            }
        }
    }
}
