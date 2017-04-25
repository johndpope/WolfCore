//
//  URLComponentsExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 11/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension URLComponents {
    public var queryDictionary: [String: String] {
        var dict = [String: String]()
        guard let queryItems = queryItems else { return dict }
        for item in queryItems {
            if let value = item.value {
                dict[item.name] = value
            }
        }
        return dict
    }

    public static func parametersDictionary(from string: String?) -> [String: String] {
        var dict = [String: String]()
        guard let string = string else { return dict }
        let items = string.components(separatedBy: "&")
        for item in items {
            let parts = item.components(separatedBy: "=")
            assert(parts.count == 2)
            dict[parts[0]] = parts[1]
        }
        return dict
    }
}
