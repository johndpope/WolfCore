//
//  HTTPUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public enum HTTPUtilsError: Error {
    case expectedJSONDict
    case expectedImage
}

public struct HTTPScheme: ExtensibleEnumeratedName {
    public let name: String
    public init(_ name: String) { self.name = name }

    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
    public var rawValue: String { return name }
}

extension HTTPScheme {
    public static let http = HTTPScheme("http")
    public static let https = HTTPScheme("https")
}

public struct HTTPMethod: ExtensibleEnumeratedName {
    public let name: String

    public init(_ name: String) { self.name = name }

    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
    public var rawValue: String { return name }
}

extension HTTPMethod {
    public static let get = HTTPMethod("GET")
    public static let post = HTTPMethod("POST")
    public static let patch = HTTPMethod("PATCH")
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
    public static let gif = ContentType("image/gif")
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

public struct StatusCode: ExtensibleEnumeratedName {
    public let name: Int

    public init(_ name: Int) { self.name = name }

    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public init?(rawValue: Int) { self.init(rawValue) }
    public var rawValue: Int { return name }
}

extension StatusCode {
    public static let ok = StatusCode(200)
    public static let created = StatusCode(201)
    public static let accepted = StatusCode(202)
    public static let noContent = StatusCode(204)

    public static let badRequest = StatusCode(400)
    public static let unauthorized = StatusCode(401)
    public static let forbidden = StatusCode(403)
    public static let notFound = StatusCode(404)
    public static let conflict = StatusCode(409)
    public static let tooManyRequests = StatusCode(429)

    public static let internalServerError = StatusCode(500)
    public static let notImplemented = StatusCode(501)
    public static let badGateway = StatusCode(502)
    public static let serviceUnavailable = StatusCode(503)
    public static let gatewayTimeout = StatusCode(504)
}

public class HTTP {
    public static func retrieveData(with request: URLRequest, successStatusCodes: [StatusCode] = [.ok], name: String? = nil) -> DataPromise {
        func perform(promise: DataPromise) {
            let name = name ?? request.name
            
            let token: InFlightToken! = inFlightTracker?.start(withName: name)

            let _sessionActions = HTTPActions()

            _sessionActions.didReceiveResponse = { (sessionActions, session, dataTask, response, completionHandler) in
                completionHandler(.allow)
            }

            _sessionActions.didComplete = { (sessionActions, session, task, error) in
                guard error == nil else {
                    switch error {
                    case let error as DescriptiveError:
                        if error.isCancelled {
                            inFlightTracker?.end(withToken: token, result: Result<Void>.canceled)
                            logTrace("\(token) retrieveData was cancelled")
                        }
                        dispatchOnMain {
                            promise.fail(error)
                        }
                    default:
                        inFlightTracker?.end(withToken: token, result: Result<Error>.failure(error!))
                        logError("\(token) retrieveData returned error")

                        dispatchOnMain {
                            promise.fail(error!)
                        }
                    }
                    return
                }

                guard let httpResponse = sessionActions.response as? HTTPURLResponse else {
                    fatalError("\(token) improper response type: \(sessionActions.response†)")
                }

                guard sessionActions.data != nil else {
                    let error = HTTPError(request: request, response: httpResponse)

                    inFlightTracker?.end(withToken: token, result: Result<HTTPError>.failure(error))
                    logError("\(token) No data returned")

                    dispatchOnMain {
                        promise.fail(error)
                    }
                    return
                }

                guard let statusCode = StatusCode(rawValue: httpResponse.statusCode) else {
                    let error = HTTPError(request: request, response: httpResponse, data: sessionActions.data)

                    inFlightTracker?.end(withToken: token, result: Result<HTTPError>.failure(error))
                    logError("\(token) Unknown response code: \(httpResponse.statusCode)")

                    dispatchOnMain {
                        promise.fail(error)
                    }
                    return
                }

                guard successStatusCodes.contains(statusCode) else {
                    let error = HTTPError(request: request, response: httpResponse, data: sessionActions.data)

                    inFlightTracker?.end(withToken: token, result: Result<HTTPError>.failure(error))
                    logError("\(token) Failure response code: \(statusCode)")

                    dispatchOnMain {
                        promise.fail(error)
                    }
                    return
                }

                inFlightTracker?.end(withToken: token, result: Result<HTTPURLResponse>.success(httpResponse))

                let inFlightData = sessionActions.data!
                dispatchOnMain {
                    promise.task = task
                    promise.keep(inFlightData)
                }
            }

            let sharedSession = URLSession.shared
            let config = sharedSession.configuration.copy() as! URLSessionConfiguration
            let session = URLSession(configuration: config, delegate: _sessionActions, delegateQueue: nil)
            let task = session.dataTask(with: request)
            promise.task = session.dataTask(with: request)
            task.resume()
        }

        return DataPromise(with: perform)
    }


    public static func retrieve(with request: URLRequest, successStatusCodes: [StatusCode] = [.ok], name: String? = nil) -> SuccessPromise {
        return retrieveData(with: request, successStatusCodes: successStatusCodes, name: name).then { _ in }
    }


    public static func retrieveJSON(with request: URLRequest, successStatusCodes: [StatusCode] = [.ok], name: String? = nil) -> JSONPromise {
        var request = request
        request.setAcceptContentType(.json)

        return retrieveData(with: request, successStatusCodes: successStatusCodes, name: name).then { data in
            return try data |> JSON.init
        }
    }


    public static func retrieveJSONDictionary(with request: URLRequest, successStatusCodes: [StatusCode] = [.ok], name: String? = nil) -> JSONPromise {
        return retrieveJSON(with: request, successStatusCodes: successStatusCodes, name: name).then { json in
            guard json.value is JSON.Dictionary else {
                throw HTTPUtilsError.expectedJSONDict
            }
            return json
        }
    }


    #if !os(Linux)
    public static func retrieveImage(with request: URLRequest, successStatusCodes: [StatusCode] = [.ok], name: String? = nil) -> ImagePromise {
        return retrieveData(with: request, successStatusCodes: successStatusCodes, name: name).then { data in
            guard let image = OSImage(data: data) else {
                throw HTTPUtilsError.expectedImage
            }
            return image
        }
    }
    #endif
}

extension URLSessionTask: Cancelable {
    public var isCanceled: Bool { return false }
}

extension URLRequest {
    public func value(for headerField: HeaderField) -> String? {
        return value(forHTTPHeaderField: headerField.rawValue)
    }

    public mutating func setMethod(_ method: HTTPMethod) {
        httpMethod = method.rawValue
    }

    public mutating func setValue(_ value: String?, for headerField: HeaderField) {
        setValue(value, forHTTPHeaderField: headerField.rawValue)
    }

    public mutating func addValue(_ value: String, for headerField: HeaderField) {
        addValue(value, forHTTPHeaderField: headerField.rawValue)
    }

    public mutating func setAcceptContentType(_ contentType: ContentType) {
        setValue(contentType.rawValue, for: .accept)
    }

    public mutating func setAuthorization(_ value: String) {
        setValue(value, for: .authorization)
    }

    public var name: String {
        var name = [String]()
        name.append(httpMethod†)
        if let url = self.url {
            name.append(url.path)
        }
        return name.joined(separator: " ")
    }

    public func printRequest(includeAuxFields: Bool = false) {
        print("request:")
        print("\turl: \(url†)")
        print("\thttpMethod: \(httpMethod†)")
        print("\tallHTTPHeaderFields: \(allHTTPHeaderFields?.count ?? 0)")
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                print("\t\t\(key): \(value)")
            }
        }
        print("\thttpBody: \(httpBody?.count ?? 0)")
        if let data = httpBody {
            do {
                let s = try (data |> JSON.init).prettyString
                let ss = s.components(separatedBy: "\n")
                let sss = ss.joined(separator: "\n\t\t")
                print("\t\t\(sss)")
            } catch {
                print("Non-JSON Data: \(data)")
            }
        }

        guard includeAuxFields else { return }

        let cachePolicyStrings: [URLRequest.CachePolicy: String] = [
            .useProtocolCachePolicy: ".useProtocolCachePolicy",
            .reloadIgnoringLocalCacheData: ".reloadIgnoringLocalCacheData",
            .returnCacheDataElseLoad: ".returnCacheDataElseLoad",
            .returnCacheDataDontLoad: ".returnCacheDataDontLoad",
            ]
        let networkServiceTypes: [URLRequest.NetworkServiceType: String]
        if #available(iOS 10.0, *) {
            networkServiceTypes = [
                .`default`: ".default",
                .voip: ".voip",
                .video: ".video",
                .background: ".background",
                .voice: ".voice",
                .networkServiceTypeCallSignaling: ".networkServiceTypeCallSignaling",
            ]
        } else {
            networkServiceTypes = [
                .`default`: ".default",
                .voip: ".voip",
                .video: ".video",
                .background: ".background",
                .voice: ".voice",
            ]
        }

        print("\ttimeoutInterval: \(timeoutInterval)")
        print("\tcachePolicy: \(cachePolicyStrings[cachePolicy]!)")
        print("\tallowsCellularAccess: \(allowsCellularAccess)")
        print("\thttpShouldHandleCookies: \(httpShouldHandleCookies)")
        print("\thttpShouldUsePipelining: \(httpShouldUsePipelining)")
        print("\tmainDocumentURL: \(mainDocumentURL†)")
        print("\tnetworkServiceType: \(networkServiceTypes[networkServiceType]!)")
    }
}

extension HTTPURLResponse {
    public func value(for headerField: HeaderField) -> String? {
        return allHeaderFields[headerField.rawValue] as? String
    }
}
