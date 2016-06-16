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

public var logOutputStream: OutputStream = standardErrorOutputStream
public var logger: Log? = Log()

public class Log {
    public var level = LogLevel.Info
    public var locationLevel = LogLevel.Error
    public private(set) var groups = Set<String>()

    public func print<T>(_ message: @autoclosure () -> T, level: LogLevel, obj: Any? = nil, group: String? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        if level.rawValue >= self.level.rawValue {
            if group == nil || groups.contains(group!) {
                let a = Joiner()
                a.append(level.symbol)

                var secondSymbol = false

                if let group = group {
                    let b = Joiner(left: "[", separator: ", ", right: "]")
                    b.append(group)
                    a.append(b)
                    secondSymbol = true
                }

                if let obj = obj {
                    let c = Joiner(left: "<", separator: ", ", right: ">")
                    c.append(obj)
                    a.append(c)
                    secondSymbol = true
                }

                if secondSymbol {
                    a.append("\t", level.symbol)
                }
                a.append(message())

                logOutputStream.write(a.description)
                logOutputStream.write("\n")

                if level.rawValue >= self.locationLevel.rawValue {
                    let d = Joiner(separator: ", ")
                    d.append(shorten(file: file), "line: \(line)", function)
                    Swift.print("\t", d)
                }
            }
        }
    }

    public func setGroup(group: String, active: Bool = true) {
        if active {
            groups.insert(group)
        } else {
            groups.remove(group)
        }
    }

    private func shorten(file: String) -> String {
        #if os(iOS) || os(OSX) || os(tvOS)
            let components = (file as NSString).pathComponents
            let originalCount = components.count
            let newCount = min(3, components.count)
            let end = originalCount
            let begin = end - newCount
            let lastComponents = components[begin..<end]
            let result = NSString.path(withComponents: Array<String>(lastComponents))
            return result
        #else
            return file
        #endif
    }

    public func trace<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: String? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .Trace, obj: obj, group: group, file, line, function)
    }

    public func info<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: String? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .Info, obj: obj, group: group, file, line, function)
    }

    public func warning<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: String? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .Warning, obj: obj, group: group, file, line, function)
    }

    public func error<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: String? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .Error, obj: obj, group: group, file, line, function)
    }
}

public func logTrace<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: String? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.trace(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logInfo<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: String? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.info(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logWarning<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: String? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.warning(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logError<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: String? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.error(message, obj: obj, group: group, file, line, function)
    #endif
}
