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
}
