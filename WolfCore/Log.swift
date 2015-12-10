//
//  Log.swift
//  WolfCore
//
//  Created by Robert McNally on 12/10/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import Foundation

public enum LogLevel: Int {
    case Trace
    case Info
    case Warning
    case Error
}

public var log: Log? = Log()

public class Log {
    public var level = LogLevel.Info
    public private(set) var groups = Set<String>()
    
    public func print(@autoclosure message: () -> String, level: LogLevel, group: String? = nil) {
        if level.rawValue >= self.level.rawValue {
            if group == nil || groups.contains(group!) {
                Swift.print("\(level) \(group): \(message())")
            }
        }
    }
    
    public func trace(@autoclosure message: () -> String, group: String? = nil) {
        self.print(message, level: .Trace, group: group)
    }
    
    public func info(@autoclosure message: () -> String, group: String? = nil) {
        self.print(message, level: .Info, group: group)
    }
    
    public func warning(@autoclosure message: () -> String, group: String? = nil) {
        self.print(message, level: .Warning, group: group)
    }
    
    public func error(@autoclosure message: () -> String, group: String? = nil) {
        self.print(message, level: .Error, group: group)
    }
}
