//
//  HTTPDebugging.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/3/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension NSURLRequest {
    public func printRequest() {
        let method = WolfCore.HTTPMethod(rawValue: self.httpMethod!)
        print(".\(method!.rawValue) \(url!)")
        print("Host: \(url!.host!)")
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                print("\(key): \(value)")
            }
            print("")
            if let contentType = headers[HeaderField.contentType.rawValue] {
                if contentType == ContentType.json.rawValue {
                    if let bodyData = httpBody {
                        let text = try! bodyData |> UTF8.init |> String.init
                        print (text)
                    }
                }
            }
        }
    }
}
