//
//  URLExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 6/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension URL {
    public static func retrieveData(from url: URL) throws -> Data {
        return try Data(contentsOf: url)
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
