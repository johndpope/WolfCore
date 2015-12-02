//
//  Result.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

// This enum represents a generic process result.
// On success it is associated with a generic, process-dependent type.
// On failure it is associated with an ErrorType.

public protocol ResultSummary {
    var isSuccess: Bool { get }
    var message: String? { get }
}

public enum Result<T>: ResultSummary {
    case Success(T)
    case Failure(Error)
    
    public var isSuccess: Bool {
        switch(self) {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }
    
    public var message: String? {
        switch(self) {
        case .Success:
            return nil
        case .Failure(let error):
            return error.message
        }
    }
}
