//
//  HTTPCacheLayer.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public class HTTPCacheLayer: CacheLayer {
    public init() {
        logTrace("init", obj: self, group: .cache)
    }

    public func store(data: Data, forURL url: URL) {
        logTrace("storeData forURL: \(url)", obj: self, group: .cache)
        // Do nothing.
    }

    public func retrieveData(forURL url: URL, completion: @escaping CacheLayerCompletion) {
        logTrace("retrieveDataForURL: \(url)", obj: self, group: .cache)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = HTTPMethod.get.rawValue
        HTTP.retrieveData(
            with: request,
            successStatusCodes: [.ok],
            name: "CacheRetrieve",
            success: { (response, rawData) in
                var contentType: ContentType?
                if let contentTypeString = response.allHeaderFields[HeaderField.contentType.rawValue] as? String {
                    contentType = ContentType(rawValue: contentTypeString)
                }

                let encoding = response.allHeaderFields[HeaderField.encoding.rawValue] as? String

                guard encoding == nil else {
                    logError("Unsupported encoding: \(encoding†)", obj: self)
                    completion(nil)
                    return
                }

                var data: Data?
                if let contentType = contentType {
                    switch contentType {
                    case ContentType.jpg:
                        data = OSImage(data: rawData)?.serialize()
                    case ContentType.png:
                        data = OSImage(data: rawData)?.serialize()
                    case ContentType.gif:
                        data = OSImage(data: rawData)?.serialize()
                    case ContentType.pdf:
                        data = rawData
                    default:
                        logError("Unsupported content type: \(contentType)", obj: self)
                    }
                }

                completion(data)
        },
            failure: { error in
                logError("Retrieving cache URL: \(url) (\(error))", obj: self)
                completion(nil)
        },
            finally: nil
        )
    }

    public func removeData(forURL url: URL) {
        logTrace("removeDataForURL: \(url)", obj: self, group: .cache)
        // Do nothing.
    }

    public func removeAll() {
        logTrace("removeAll", obj: self, group: .cache)
        // Do nothing.
    }
}
