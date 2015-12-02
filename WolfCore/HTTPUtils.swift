//
//  HTTPUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case HEAD = "HEAD"
    case OPTIONS = "OPTIONS"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}

public enum ContentType: String {
    case JSON = "application/json"
    case JPG = "image/jpeg"
    case PNG = "image/png"
    case HTML = "text/html"
    case TXT = "text/plain"
}

public enum HeaderField: String {
    case Accept = "Accept"
    case ContentType = "Content-Type"
}

public enum ResponseCode: Int {
    case OK = 200
    case Created = 201
    case Accepted = 202
    case NoContent = 204
    
    case BadRequest = 400
    case Forbidden = 403
    case NotFound = 404
    
    case InternalServerError = 500
    case NotImplemented = 501
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
}

public func retrieveURLRequest(request: NSMutableURLRequest,
    success: (NSHTTPURLResponse, NSData) -> Void,
    failure: (ErrorType) -> Void,
    finally: (() -> Void)? = nil) {

        let session = NSURLSession.sharedSession()
        
        print(request)
        
        let task = session.dataTaskWithRequest(request) { (let data, let response, let error) in
            guard error == nil else {
                dispatchOnMain { failure(error!) }
                dispatchOnMain { finally?() }
                return
            }

            guard let httpResponse = response as? NSHTTPURLResponse else {
                fatalError("improper response type: \(response)")
            }

            guard data != nil else {
                dispatchOnMain { failure(HTTPError(response: httpResponse)) }
                dispatchOnMain { finally?() }
                return
            }
            
            dispatchOnMain { success(httpResponse, data!) }
            dispatchOnMain { finally?() }
        }
        
        task.resume()
}

public func retrieveJSONURLRequest(request: NSMutableURLRequest,
    success: (NSHTTPURLResponse, JSONObject) -> Void,
    failure: (ErrorType) -> Void,
    finally: (() -> Void)? = nil) {
        
        request.setValue(ContentType.JSON.rawValue, forHTTPHeaderField: HeaderField.Accept.rawValue)
        
        retrieveURLRequest(request, success: { (response, data) -> Void in
            print(String(data: data, encoding: NSUTF8StringEncoding))
            if let json = data.json {
                success(response, json)
            } else {
                failure(GeneralError(message: "Could not parse JSON."))
            }
            },
            failure: failure,
            finally: finally
        )
}

public func retrieveImageURL(url: NSURL,
    success: (UIImage) -> Void,
    failure: (ErrorType) -> Void,
    finally: (() -> Void)? = nil) {
 
        let request = NSMutableURLRequest()
        request.HTTPMethod = HTTPMethod.GET.rawValue
        request.URL = url
        
        retrieveURLRequest(request,
            success: { (response, data) -> Void in
                if let image = UIImage(data: data) {
                    success(image)
                } else {
                    failure(HTTPError(response: response))
                }
            },
            failure: failure,
            finally: finally
        )
}
