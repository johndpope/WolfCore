//
//  HTTPError.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public struct HTTPError: ErrorProto {
    public let response: HTTPURLResponse
    public let data: Data?

    public init(response: HTTPURLResponse, data: Data? = nil) {
        self.response = response
        self.data = data
    }

    public var message: String {
        return HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }

    public var code: Int {
        return response.statusCode
    }

    public var statusCode: StatusCode {
        return StatusCode(rawValue: code)!
    }

    public var identifier: String {
        return "HTTPError(\(code))"
    }

    public var json: JSON? {
        guard let data = data else { return nil }
        do {
            return try data |> JSON.init
        } catch {
            return nil
        }
    }

    public var isCancelled: Bool { return false }
}

extension HTTPError: CustomStringConvertible {
    public var description: String {
        return "HTTPError(\(code) \(message))"
    }
}
