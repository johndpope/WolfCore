//
//  Log.swift
//  WolfCore
//
//  Created by Robert McNally on 12/10/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

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

public var logOutputStream: OutputStreamType = standardErrorOutputStream
public var logger: Log? = Log()

public class Log {
    public var level = LogLevel.Info
    public var locationLevel = LogLevel.Error
    public private(set) var groups = Set<String>()

    public func print<T>(@autoclosure message: () -> T, level: LogLevel, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
        if level.rawValue >= self.level.rawValue {
            if group == nil || groups.contains(group!) {
                let a = Joiner("", "", " ", level.symbol)

                var secondSymbol = false

                if let group = group {
                    let b = Joiner("[", "]", ", ")
                    b.append(group)
                    a.append(b)
                    secondSymbol = true
                }

                if let obj = obj {
                    let c = Joiner("<", ">", ", ")
                    c.append(obj)
                    a.append(c)
                    secondSymbol = true
                }

                if secondSymbol {
                    a.append("\t", level.symbol)
                }
                a.append(message())

                logOutputStream.write(a.description)

                if level.rawValue >= self.locationLevel.rawValue {
                    let d = Joiner("", "", ", ", shortenFile(file), "line: \(line)", function)
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

    private func shortenFile(file: String) -> String {
        #if os(iOS) || os(OSX) || os(tvOS)
            let components = (file as NSString).pathComponents
            let originalCount = components.count
            let newCount = min(3, components.count)
            let end = originalCount
            let begin = end - newCount
            let lastComponents = components[begin..<end]
            let result = NSString.pathWithComponents(Array<String>(lastComponents))
            return result
        #else
            return file
        #endif
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
        logger?.trace(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logInfo<T>(@autoclosure message: () -> T, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
    #if !NO_LOG
        logger?.info(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logWarning<T>(@autoclosure message: () -> T, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
    #if !NO_LOG
        logger?.warning(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logError<T>(@autoclosure message: () -> T, obj: Any? = nil, group: String? = nil, _ file: String = __FILE__, _ line: Int = __LINE__, _ function: String = __FUNCTION__) {
    #if !NO_LOG
        logger?.error(message, obj: obj, group: group, file, line, function)
    #endif
}
