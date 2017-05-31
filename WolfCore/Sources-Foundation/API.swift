//
//  API.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/2/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let loggedOut = Notification.Name("loggedOut")
}

open class API<C: Credentials> {
    public typealias CredentialsType = C

    private let endpoint: Endpoint
    private let authorizationHeaderField: HeaderField

    public var debugPrintRequests = false

    public var credentials: CredentialsType? {
        didSet {
            if credentials != nil {
                credentials!.save()
            } else {
                CredentialsType.delete()
            }
        }
    }

    public init(endpoint: Endpoint, authorizationHeaderField: HeaderField = .authorization) {
        self.endpoint = endpoint
        self.authorizationHeaderField = authorizationHeaderField
        self.credentials = CredentialsType.load()
    }

    public var hasCredentials: Bool {
        return credentials != nil
    }

    public enum Error: Swift.Error {
        case credentialsRequired
    }

    public var authorization: String {
        get {
            return credentials!.authorization
        }

        set {
            credentials!.authorization = newValue
        }
    }

    public func newRequest(method: HTTPMethod, path: [Any]? = nil, isAuth: Bool, body json: JSON? = nil) throws -> URLRequest {
        guard !isAuth || credentials != nil else {
            throw Error.credentialsRequired
        }

        let url = URL(scheme: HTTPScheme.https, host: endpoint.host, basePath: endpoint.basePath, pathComponents: path)
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setClientRequestID()
        request.setMethod(method)
        request.setConnection(.close)
        if let json = json {
            request.httpBody = json.data
            request.setContentType(.json, charset: .utf8)
            request.setContentLength(json.data.count)
        }
        if isAuth {
            request.setValue(authorization, for: authorizationHeaderField)
        }

        if debugPrintRequests {
            request.printRequest()
        }

        return request
    }

    public func newPromise<T>(method: HTTPMethod, path: [Any]? = nil, isAuth: Bool = true, body json: JSON? = nil, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil, with f: @escaping (JSON) throws -> T) -> Promise<T> {
        do {
            let request = try self.newRequest(method: method, path: path, isAuth: isAuth, body: json)
            return HTTP.retrieveJSONDictionary(with: request, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock).then { json in
                return try f(json)
            }.recover { (error, promise) in
                self.handle(error: error, promise: promise)
            }
        } catch let error {
            return Promise<T>(error: error)
        }
    }

    public func newPromise(method: HTTPMethod, path: [Any]? = nil, isAuth: Bool = true, body json: JSON? = nil, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil) -> SuccessPromise {
        do {
            let request = try self.newRequest(method: method, path: path, isAuth: isAuth, body: json)
            return HTTP.retrieve(with: request, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock).succeed().recover { (error, promise) in
                self.handle(error: error, promise: promise)
            }
        } catch let error {
            return SuccessPromise(error: error)
        }
    }

    private func handle<T>(error: Swift.Error, promise: Promise<T>) {
        if error.httpStatusCode == .unauthorized {
            promise.cancel()
            logout()
        } else {
            promise.fail(error)
        }
    }

    public func logout() {
        credentials = nil
        notificationCenter.post(name: .loggedOut, object: self)
    }
}
