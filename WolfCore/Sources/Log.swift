//
//  Log.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/10/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import Foundation

public enum LogLevel: Int {
    case trace
    case info
    case warning
    case error

    private static let symbols = ["🔷", "✅", "⚠️", "🚫"]

    public var symbol: String {
        return type(of: self).symbols[rawValue]
    }
}

public var logger: Log? = Log()

public class Log {
    public struct GroupName: ExtensibleEnumeratedName {
        public let name: String

        public init(_ name: String) { self.name = name }

        // Hashable
        public var hashValue: Int { return name.hashValue }

        // RawRepresentable
        public init?(rawValue: String) { self.init(rawValue) }
        public var rawValue: String { return name }
    }

    public var level = LogLevel.info
    public var locationLevel = LogLevel.error
    public private(set) var groups = Set<GroupName>()

    public func print<T>(_ message: @autoclosure () -> T, level: LogLevel, obj: Any? = nil, group: GroupName? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        if level.rawValue >= self.level.rawValue {
            if group == nil || groups.contains(group!) {
                let a = Joiner()
                a.append(level.symbol)

                var secondSymbol = false

                if let group = group {
                    let b = Joiner(left: "[", separator: ", ", right: "]")
                    b.append(group.name)
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

                Swift.print(a)

                if level.rawValue >= self.locationLevel.rawValue {
                    let d = Joiner(separator: ", ")
                    d.append(shortenFile(file), "line: \(line)", function)
                    Swift.print("\t", d)
                }
            }
        }
    }

    public func set(group: GroupName, active: Bool = true) {
        if active {
            groups.insert(group)
        } else {
            groups.remove(group)
        }
    }

    private func shortenFile(_ file: String) -> String {
        let components = (file as NSString).pathComponents
        let originalCount = components.count
        let newCount = min(3, components.count)
        let end = originalCount
        let begin = end - newCount
        let lastComponents = components[begin..<end]
        let result = NSString.path(withComponents: [String](lastComponents))
        return result
    }

    public func trace<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: GroupName? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .trace, obj: obj, group: group, file, line, function)
    }

    public func info<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: GroupName? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .info, obj: obj, group: group, file, line, function)
    }

    public func warning<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: GroupName? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .warning, obj: obj, group: group, file, line, function)
    }

    public func error<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: GroupName? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .error, obj: obj, group: group, file, line, function)
    }
}

public func logTrace<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: Log.GroupName? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.trace(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logInfo<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: Log.GroupName? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.info(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logWarning<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: Log.GroupName? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.warning(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logError<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: Log.GroupName? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.error(message, obj: obj, group: group, file, line, function)
    #endif
}
