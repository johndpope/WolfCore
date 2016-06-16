//
//  HTTPUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public struct UnknownJSONError: ErrorProtocol {
    public init() { }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case head = "HEAD"
    case options = "OPTIONS"
    case put = "PUT"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

public enum ContentType: String {
    case json = "application/json"
    case jpg = "image/jpeg"
    case png = "image/png"
    case html = "text/html"
    case txt = "text/plain"
}

public enum HeaderField: String {
    case accept = "Accept"
    case contentType = "Content-Type"
    case encoding = "Encoding"
    case authorization = "Authorization"
    case contentRange = "Content-Range"
    case connection = "connection"
    case uploadToken = "upload-token"
    case contentLength = "Content-Length"
}

public enum StatusCode: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204

    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404

    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
}

public class HTTP {
    public static func retrieveData(
        withRequest request: URLRequest,
        successStatusCodes: [StatusCode], name: String,
        success: (HTTPURLResponse, Data) -> Void,
        failure: ErrorBlock,
        finally: Block?) {

        let session = URLSession.shared()

        #if !os(tvOS)
            let token = inFlightTracker.start(withName: name)
        #endif

        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {

                #if !os(tvOS)
                    inFlightTracker.end(withToken: token, result: Result<NSError>.Failure(error!))
                    logError("\(token) dataTaskWithRequest returned error")
                #endif

                dispatchOnMain { failure(error!) }
                dispatchOnMain { finally?() }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
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
                inFlightTracker.end(withToken: token, result: Result<HTTPURLResponse>.Success(httpResponse))
            #endif

            dispatchOnMain { success(httpResponse, data!) }
            dispatchOnMain { finally?() }
        }

        task.resume()
    }

    public static func retrieveResponse(
        withRequest request: URLRequest,
        successStatusCodes: [StatusCode],
        name: String,
        success: (HTTPURLResponse) -> Void,
        failure: ErrorBlock,
        finally: Block?) {

        retrieveData(
            withRequest: request,
            successStatusCodes: successStatusCodes,
            name: name,
            success: { (response, _) in
                success(response)
            },
            failure: failure,
            finally: finally
        )
    }

    public static func retrieve(
        withRequest request: URLRequest,
        successStatusCodes: [StatusCode],
        name: String,
        success: Block,
        failure: ErrorBlock,
        finally: Block?) {
        retrieveResponse(
            withRequest: request,
            successStatusCodes: successStatusCodes,
            name: name,
            success: { response in
                success()
            },
            failure: failure,
            finally: finally
        )
    }

    public static func retrieveJSON(
        withRequest request: URLRequest,
        successStatusCodes: [StatusCode],
        name: String,
        success: (HTTPURLResponse, JSONObject) -> Void,
        failure: ErrorBlock,
        finally: Block?) {

        var request = request
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HeaderField.accept.rawValue)

        retrieveData(
            withRequest: request,
            successStatusCodes: successStatusCodes,
            name: name,
            success: { (response, data) in
                do {
                    let json = try data |> Data.jsonObject
                    success(response, json)
                } catch let error {
                    failure(error)
                }
            },
            failure: failure,
            finally: finally
        )
    }

    public static func retrieveJSONDictionary(
        withRequest request: URLRequest,
        successStatusCodes: [StatusCode], name: String,
        success: (HTTPURLResponse, JSONDictionary) -> Void,
        failure: ErrorBlock,
        finally: Block?) {
        retrieveJSON(
            withRequest: request,
            successStatusCodes: successStatusCodes,
            name: name,
            success: { (response, json) in
                guard let jsonDict = json as? JSONDictionary else {
                    failure(UnknownJSONError())
                    return
                }

                success(response, jsonDict)
            },
            failure: failure,
            finally: finally
        )
    }

    public static func retrieveImage(
        withURL url: URL,
        successStatusCodes: [StatusCode],
        name: String,
        success: (OSImage) -> Void,
        failure: ErrorBlock,
        finally: Block?) {

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        retrieveData(
            withRequest: request,
            successStatusCodes: successStatusCodes,
            name: name,
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
