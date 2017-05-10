//
//  API.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/2/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

open class API {
    private typealias `Self` = API

    private let endpoint: Endpoint
    public var credentials: Credentials?
    public static let loggedOut = NSNotification.Name("loggedOut")

    public init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }

    public enum Error: Swift.Error {
        case credentialsRequired
    }

    public func newRequest(method: HTTPMethod, path: [Any]? = nil, isAuth: Bool, body json: JSON? = nil) throws -> URLRequest {
        guard !isAuth || credentials != nil else {
            throw Error.credentialsRequired
        }

        let url = URL(scheme: HTTPScheme.https, host: endpoint.host, basePath: endpoint.basePath, pathComponents: path)
        var request = URLRequest(url: url)
        request.setClientRequestID()
        request.setMethod(method)
        if let json = json {
            request.httpBody = json.data
        }
        if isAuth {
            request.setAuthorization(credentials!.authorization)
        }
        //request.printRequest()
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
        credentials?.delete()
        credentials = nil
        notificationCenter.post(name: Self.loggedOut, object: self)
    }
}
