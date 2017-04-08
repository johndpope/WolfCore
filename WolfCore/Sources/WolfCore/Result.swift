//
//  Result.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/17/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

/// Classes that represent process results must conform to this protocol.
public protocol ResultSummary {
    /// Returns true if the process completed successfully; false otherwise.
    var isSuccess: Bool { get }

    /// Returns true if the process was cancelled; false otherwise.
    var isCanceled: Bool { get }

    /// Returns a human-readable error message, or `nil` if none was provided.
    var message: String? { get }

    /// Returns a numeric error code, or `nil` if none was provided.
    var code: Int? { get }

    /// Returns a non-user-facing indentifier used for automated UI testing
    var identifier: String? { get }

    /// Returns the error object
    var error: Error? { get }
}

/// Represents a process result with a specific type returned upon success.
/// On success it is associated with a generic, process-dependent type.
/// On failure it is associated with an Error.
public enum Result<T>: ResultSummary {
    case success(T)
    case failure(Error)
    case canceled

    /// Returns true if the process completed successfully; false otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure, .canceled:
            return false
        }
    }

    public var isCanceled: Bool {
        switch self {
        case .success, .failure:
            return false
        case .canceled:
            return true
        }
    }

    /// Returns a human-readable error message, or `nil` if none was provided.
    public var message: String? {
        switch self {
        case .success, .canceled:
            return nil
        case .failure(let error as DescriptiveError):
            return error.message
        default:
            return nil
        }
    }

    /// Returns a numeric error code, or `nil` if none was provided.
    public var code: Int? {
        switch self {
        case .success, .canceled:
            return nil
        case .failure(let error as DescriptiveError):
            return error.code
        default:
            return nil
        }
    }

    /// Returns a non-user-facing indentifier used for automated UI testing
    public var identifier: String? {
        switch self {
        case .success, .canceled:
            return nil
        case .failure(let error as DescriptiveError):
            return error.identifier
        default:
            return nil
        }
    }

    /// Returns the error object
    public var error: Error? {
        switch self {
        case .success, .canceled:
            return nil
        case .failure(let error):
            return error
        }
    }
}
