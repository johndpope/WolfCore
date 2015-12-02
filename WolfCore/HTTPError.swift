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
    
    public init(response: NSHTTPURLResponse) {
        self.response = response
    }
    
    public var message: String {
        return NSHTTPURLResponse.localizedStringForStatusCode(response.statusCode)
    }
}

extension HTTPError: CustomStringConvertible {
    public var description: String {
        return "HTTPError(\(message))"
    }
}
