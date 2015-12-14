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
    
    private static let symbols = ["🔷", "✅", "⚠️", "🚫"]
    
    public var symbol: String {
        return self.dynamicType.symbols[rawValue]
    }
}

public var log: Log? = Log()

public class Log {
    public var level = LogLevel.Info
    public private(set) var groups = Set<String>()
    
    public func print(@autoclosure message: () -> String, level: LogLevel, obj: Any? = nil, group: String? = nil) {
        if level.rawValue >= self.level.rawValue {
            if group == nil || groups.contains(group!) {
                var e = [String]()
                e.append("\(level.symbol)")
                if let group = group {
                    e.append("\(group)")
                }
                if let obj = obj {
                    e.append("\(obj)")
                }
                Swift.print("\(e.joinWithSeparator(" ")): \(message())")
            }
        }
    }
    
    public func trace(@autoclosure message: () -> String, obj: Any? = nil, group: String? = nil) {
        self.print(message, level: .Trace, obj: obj, group: group)
    }
    
    public func info(@autoclosure message: () -> String, obj: Any? = nil, group: String? = nil) {
        self.print(message, level: .Info, obj: obj, group: group)
    }
    
    public func warning(@autoclosure message: () -> String, obj: Any? = nil, group: String? = nil) {
        self.print(message, level: .Warning, obj: obj, group: group)
    }
    
    public func error(@autoclosure message: () -> String, obj: Any? = nil, group: String? = nil) {
        self.print(message, level: .Error, obj: obj, group: group)
    }
    
    public func error(error: ErrorType, obj: Any? = nil, group: String? = nil) {
        self.print("\(error)", level: .Error, obj: obj, group: group)
    }
}
