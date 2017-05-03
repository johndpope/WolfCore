//
//  Endpoint.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/2/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

public struct Endpoint {
    public let host: String
    public let basePath: String

    public init(host: String, basePath: String) {
        self.host = host
        self.basePath = basePath
    }
}
