//
//  Joiner.swift
//  WolfCore
//
//  Created by Robert McNally on 12/15/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

public class Joiner {
    private var left: String
    private var right: String
    private var separator: String
    private var objs = [Any]()

    public init(left: String = "", separator: String = " ", right: String = "") {
        self.left = left
        self.right = right
        self.separator = separator
    }

    public func append(_ objs: Any...) {
        self.objs.append(contentsOf: objs)
    }
}

extension Joiner: CustomStringConvertible {
    public var description: String {
        var s = [String]()
        for o in objs {
            s.append("\(o)")
        }
        let t = s.joined(separator: separator)
        return "\(left)\(t)\(right)"
    }
}
