//
//  HTTPUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

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
    case Encoding = "Encoding"
    case Authorization = "Authorization"
}

public enum StatusCode: Int {
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

public class HTTP {
    public static func retrieve(withRequest request: NSMutableURLRequest, successStatusCodes: [StatusCode], name: String,
                                            success: (NSHTTPURLResponse, NSData) -> Void,
                                            failure: ErrorBlock,
                                            finally: DispatchBlock? = nil) {

        let session = NSURLSession.sharedSession()

        #if !os(tvOS)
            let token = inFlightTracker.start(withName: name)
        #endif

        let task = session.dataTaskWithRequest(request) { (let data, let response, let error) in
            guard error == nil else {

                #if !os(tvOS)
                    inFlightTracker.end(withToken: token, result: Result<NSError>.Failure(error!))
                    logError("\(token) dataTaskWithRequest returned error")
                #endif

                dispatchOnMain { failure(error!) }
                dispatchOnMain { finally?() }
                return
            }

            guard let httpResponse = response as? NSHTTPURLResponse else {
                #if !os(tvOS)
                    fatalError("\(token) improper response type: \(response)")
                #else
                    return
                #endif
            }

            guard data != nil else {
                let error = HTTPError(response: httpResponse)

                #if !os(tvOS)
                    inFlightTracker.end(withToken: token, result: Result<HTTPError>.Failure(error))
                    logError("\(token) No data returned")
                #endif

                dispatchOnMain { failure(error) }
                dispatchOnMain { finally?() }
                return
            }

            guard let statusCode = StatusCode(rawValue: httpResponse.statusCode) else {
                let error = HTTPError(response: httpResponse, data: data)

                #if !os(tvOS)
                    inFlightTracker.end(withToken: token, result: Result<HTTPError>.Failure(error))
                    logError("\(token) Unknown response code: \(httpResponse.statusCode)")
                #endif
                dispatchOnMain { failure(error) }
                dispatchOnMain { finally?() }
                return
            }

            guard successStatusCodes.contains(statusCode) else {
                let error = HTTPError(response: httpResponse, data: data)

                #if !os(tvOS)
                    inFlightTracker.end(withToken: token, result: Result<HTTPError>.Failure(error))
                    logError("\(token) Failure response code: \(statusCode)")
                #endif

                dispatchOnMain { failure(error) }
                dispatchOnMain { finally?() }
                return
            }

            #if !os(tvOS)
                inFlightTracker.end(withToken: token, result: Result<NSHTTPURLResponse>.Success(httpResponse))
            #endif

            dispatchOnMain { success(httpResponse, data!) }
            dispatchOnMain { finally?() }
        }

        task.resume()
    }

    public static func retrieveJSON(withRequest request: NSMutableURLRequest, successStatusCodes: [StatusCode], name: String,
                                                success: (NSHTTPURLResponse, JSONObject) -> Void,
                                                failure: ErrorBlock,
                                                finally: DispatchBlock? = nil) {

        request.setValue(ContentType.JSON.rawValue, forHTTPHeaderField: HeaderField.Accept.rawValue)

        retrieve(withRequest: request, successStatusCodes: successStatusCodes, name: name,
                 success: { (response, data) in
                    do {
                        let json = try JSON.decode(data)
                        success(response, json)
                    } catch let error {
                        failure(error)
                    }
            },
                 failure: failure,
                 finally: finally
        )
    }

    public static func retrieveImage(withURL url: NSURL, successStatusCodes: [StatusCode], name: String,
                                             success: (OSImage) -> Void,
                                             failure: ErrorBlock,
                                             finally: DispatchBlock? = nil) {

        let request = NSMutableURLRequest()
        request.HTTPMethod = HTTPMethod.GET.rawValue
        request.URL = url

        retrieve(withRequest: request, successStatusCodes: successStatusCodes, name: name,
                 success: { (response, data) in
                    if let image = OSImage(data: data) {
                        success(image)
                    } else {
                        failure(HTTPError(response: response, data: data))
                    }
            },
                 failure: failure,
                 finally: finally
        )
    }
}
