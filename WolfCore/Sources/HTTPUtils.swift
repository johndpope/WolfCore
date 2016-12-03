//
//  HTTPUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public enum HTTPUtilsError: Error {
    case expectedJSONDict
}

public struct HTTPMethod: ExtensibleEnumeratedName {
    public let name: String

    public init(_ name: String) { self.name = name}

    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
    public var rawValue: String { return name }
}

extension HTTPMethod {
    public static let get = HTTPMethod("GET")
    public static let post = HTTPMethod("POST")
    public static let head = HTTPMethod("HEAD")
    public static let options = HTTPMethod("OPTIONS")
    public static let put = HTTPMethod("PUT")
    public static let delete = HTTPMethod("DELETE")
    public static let trace = HTTPMethod("TRACE")
    public static let connect = HTTPMethod("CONNECT")
}

public struct ContentType: ExtensibleEnumeratedName {
    public let name: String

    public init(_ name: String) { self.name = name}

    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
    public var rawValue: String { return name }
}

extension ContentType {
    public static let json = ContentType("application/json")
    public static let jpg = ContentType("image/jpeg")
    public static let png = ContentType("image/png")
    public static let html = ContentType("text/html")
    public static let txt = ContentType("text/plain")
    public static let pdf = ContentType("application/pdf")
}

public struct HeaderField: ExtensibleEnumeratedName {
    public let name: String

    public init(_ name: String) { self.name = name}

    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
    public var rawValue: String { return name }
}

extension HeaderField {
    public static let accept = HeaderField("Accept")
    public static let contentType = HeaderField("Content-Type")
    public static let encoding = HeaderField("Encoding")
    public static let authorization = HeaderField("Authorization")
    public static let contentRange = HeaderField("Content-Range")
    public static let connection = HeaderField("connection")
    public static let uploadToken = HeaderField("upload-token")
    public static let contentLength = HeaderField("Content-Length")
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

public let baseProgressNotificationKey = NSNotification.Name("baseProgressNotificaitonKey")
public let progressKey = NSNotification.Name("progressKey")
public let unauthorizedNotificationKey = NSNotification.Name("unauthorizedNotificationKey")

public class HTTP {
    public static func send(
        request: URLRequest,
        actions: HTTPActions) -> Cancelable {
        let sharedSession = URLSession.shared
        let config = sharedSession.configuration.copy() as! URLSessionConfiguration
        let session = URLSession(configuration: config, delegate: actions, delegateQueue: nil)
        let task = session.dataTask(with: request)
        task.resume()
        return task as! Cancelable
    }

    public static func retrieveData(
        withRequest request: URLRequest,
        delegate: URLSessionDataDelegate? = nil,
        hasFileToken: Bool? = false,
        successStatusCodes: [StatusCode], name: String,
        success: @escaping (HTTPURLResponse, Data) -> Void,
        failure: @escaping ErrorBlock,
        finally: Block?) -> Cancelable {
        let token = inFlightTracker.start(withName: name)

        let _sessionActions = HTTPActions()
        _sessionActions.didReceiveResponse = { (sessionActions, session, dataTask, response, completionHandler) in
            completionHandler(.allow)
        }

        _sessionActions.didSendBodyData = { (sessionActions, session, task, bytesSent, totalBytesSent, totalBytesExpected) in
            guard hasFileToken == false else { return }
            guard totalBytesExpected > 0 else { return }
            let percentComplete: Float = (Float(totalBytesSent) / Float(totalBytesExpected)) * 1.00
            let userInfo = [progressKey : percentComplete]
            notificationCenter.post(name: baseProgressNotificationKey, object: userInfo)
        }

        _sessionActions.didComplete = { (sessionActions, session, task, error) in
            guard error == nil else {
                let error = error!
                if let error = error as? DescriptiveError {
                    if error.isCancelled {
                        inFlightTracker.end(withToken: token, result: Result<Void>.canceled)
                        logTrace("\(token) retrieveData was cancelled")
                    }
                } else {
                    inFlightTracker.end(withToken: token, result: Result<Error>.failure(error))
                    logError("\(token) retrieveData returned error")

                    dispatchOnMain {
                        failure(error)
                        finally?()
                    }
                }
                return
            }

            guard let httpResponse = sessionActions.response as? HTTPURLResponse else {
                fatalError("\(token) improper response type: \(sessionActions.response)")
            }

            guard sessionActions.data != nil else {
                let error = HTTPError(response: httpResponse)

                inFlightTracker.end(withToken: token, result: Result<HTTPError>.failure(error))
                logError("\(token) No data returned")

                dispatchOnMain {
                    failure(error)
                    finally?()
                }
                return
            }

            guard let statusCode = StatusCode(rawValue: httpResponse.statusCode) else {
                let error = HTTPError(response: httpResponse, data: sessionActions.data)

                inFlightTracker.end(withToken: token, result: Result<HTTPError>.failure(error))
                logError("\(token) Unknown response code: \(httpResponse.statusCode)")

                dispatchOnMain {
                    failure(error)
                    finally?()
                }
                return
            }

            guard successStatusCodes.contains(statusCode) else {
                let error = HTTPError(response: httpResponse, data: sessionActions.data)

                inFlightTracker.end(withToken: token, result: Result<HTTPError>.failure(error))
                logError("\(token) Failure response code: \(statusCode)")

                if error.code == 401 {
                    notificationCenter.post(name: unauthorizedNotificationKey)
                }

                dispatchOnMain {
                    failure(error)
                    finally?()
                }
                return
            }

            inFlightTracker.end(withToken: token, result: Result<HTTPURLResponse>.success(httpResponse))

            let inFlightData = sessionActions.data!
            dispatchOnMain {
                success(httpResponse, inFlightData)
                finally?()
            }
        }

        return send(request: request, actions: _sessionActions)
    }

    public static func retrieveResponse(
        withRequest request: URLRequest,
        successStatusCodes: [StatusCode],
        name: String,
        success: @escaping (HTTPURLResponse) -> Void,
        failure: @escaping ErrorBlock,
        finally: Block?) -> Cancelable {

        return retrieveData(
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
        success: @escaping Block,
        failure: @escaping ErrorBlock,
        finally: Block?) -> Cancelable {
        return retrieveResponse(
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
        success: @escaping (HTTPURLResponse, JSON) -> Void,
        failure: @escaping ErrorBlock,
        finally: Block?) -> Cancelable {

        var request = request
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HeaderField.accept.rawValue)

        return retrieveData(
            withRequest: request,
            successStatusCodes: successStatusCodes,
            name: name,
            success: { (response, data) in
                do {
                    let json = try data |> JSON.init
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
        success: @escaping (HTTPURLResponse, JSON.Dictionary) -> Void,
        failure: @escaping ErrorBlock,
        finally: Block?) -> Cancelable {
        return retrieveJSON(
            withRequest: request,
            successStatusCodes: successStatusCodes,
            name: name,
            success: { (response, json) in
                guard let jsonDict = json.value as? JSON.Dictionary else {
                    failure(HTTPUtilsError.expectedJSONDict)
                    return
                }

                success(response, jsonDict)
            },
            failure: failure,
            finally: finally
        )
    }

    #if !os(Linux)
    public static func retrieveImage(
        withURL url: URL,
        successStatusCodes: [StatusCode],
        name: String,
        success: @escaping (OSImage) -> Void,
        failure: @escaping ErrorBlock,
        finally: Block?) -> Cancelable {

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        return retrieveData(
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
    #endif
}
