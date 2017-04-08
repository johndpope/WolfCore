//
//  HTTPError.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public struct HTTPError: DescriptiveError {
    public let request: URLRequest
    public let response: HTTPURLResponse
    public let data: Data?

    public init(request: URLRequest, response: HTTPURLResponse, data: Data? = nil) {
        self.request = request
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

public func logHTTPError(_ error: Error) {
    guard let err = error as? HTTPError else {
        logError(error)
        return
    }
    err.request.printRequest()
    guard let json = err.json else {
        logError("Error contains no JSON.")
        return
    }
    guard let dict = json.value as? JSON.Dictionary else {
        logError("JSON is not dictionary.")
        return
    }
    guard let message = dict["message"] else {
        logError("Error dictionary contains no message field.")
        return
    }
    logError("message: \(message)")
}
