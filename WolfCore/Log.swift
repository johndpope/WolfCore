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
    
    public func print<T>(@autoclosure message: () -> T, level: LogLevel, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
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
    
    public func trace<T>(@autoclosure message: () -> T, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
        self.print(message, level: .Trace, obj: obj, group: group, file, line, function)
    }
    
    public func info<T>(@autoclosure message: () -> T, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
        self.print(message, level: .Info, obj: obj, group: group, file, line, function)
    }
    
    public func warning<T>(@autoclosure message: () -> T, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
        self.print(message, level: .Warning, obj: obj, group: group, file, line, function)
    }
    
    public func error<T>(@autoclosure message: () -> T, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
        self.print(message, level: .Error, obj: obj, group: group, file, line, function)
    }
}

public func logTrace<T>(@autoclosure message: () -> T, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
    #if !NO_LOG
        logTrace(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logInfo<T>(@autoclosure message: () -> T, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
    #if !NO_LOG
        logInfo(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logWarning<T>(@autoclosure message: () -> T, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
    #if !NO_LOG
        logWarning(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logError<T>(@autoclosure message: () -> T, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
    #if !NO_LOG
        logError(message, obj: obj, group: group, file, line, function)
    #endif
}
