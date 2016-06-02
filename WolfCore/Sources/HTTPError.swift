//
//  HTTPError.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public struct HTTPError: Error {
    public let response: NSHTTPURLResponse
    public let data: NSData?

    public init(response: NSHTTPURLResponse, data: NSData? = nil) {
        self.response = response
        self.data = data
    }

    public var message: String {
        return NSHTTPURLResponse.localizedStringForStatusCode(response.statusCode)
    }

    public var code: Int {
        return response.statusCode
    }

    public var statusCode: StatusCode? {
        return StatusCode(rawValue: code)
    }

    public var identifier: String {
        return "HTTPError(\(code))"
    }

    public var json: JSONObject? {
        guard let data = data else { return nil }
        do {
            return try JSON.decode(data)
        } catch {
            return nil
        }
    }
}

extension HTTPError: CustomStringConvertible {
    public var description: String {
        return "HTTPError(\(code) \(message))"
    }
}
