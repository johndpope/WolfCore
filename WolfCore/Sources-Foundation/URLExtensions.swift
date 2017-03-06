//
//  URLExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension URL {
    public static func retrieveData(from url: URL) throws -> Data {
        return try Data(contentsOf: url)
    }
}

extension URL {
    public init(scheme: HTTPScheme, host: String, basePath: String? = nil, pathComponents: [Any]? = nil) {
        var comps = URLComponents()
        comps.scheme = scheme.rawValue
        comps.host = host
        let joiner = Joiner(left: "/", separator: "/")
        if let basePath = basePath {
            joiner.append(basePath)
        }
        if let pathComponents = pathComponents {
            joiner.append(contentsOf: pathComponents)
        }
        comps.path = joiner.description
        let string = comps.string!
        self.init(string: string)!
    }
}

extension String {
    public static func url(from string: String) throws -> URL {
        guard let url = URL(string: string) else {
            throw ValidationError(message: "Could not parse url from string: \(string)", violation: "urlFormat")
        }
        return url
    }
}
