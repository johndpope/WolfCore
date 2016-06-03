//
//  HTTPDebugging.swift
//  WolfCore
//
//  Created by Robert McNally on 6/3/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension NSURLRequest {
    public func printRequest() {
        let method = WolfCore.HTTPMethod(rawValue: self.HTTPMethod!)
        print(".\(method!.rawValue) \(self.URL!)")
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                print("\(key): \(value)")
            }
            print("")
            if let contentType = headers[HeaderField.ContentType.rawValue] {
                if contentType == ContentType.JSON.rawValue {
                    if let bodyData = HTTPBody {
                        let text = try! UTF8.decode(bodyData)
                        print (text)
                    }
                }
            }
        }
    }
}
