//
//  OutputStreamUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 2/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public var standardOutputStream = StandardOutputStream()
public var standardErrorOutputStream = StandardErrorOutputStream()

public class StandardErrorOutputStream: OutputStreamType {
    public func write(string: String) {
        let stderr = NSFileHandle.fileHandleWithStandardError()
        stderr.writeData(string.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
}

public class StandardOutputStream: OutputStreamType {
    public func write(string: String) {
        let stdout = NSFileHandle.fileHandleWithStandardOutput()
        stdout.writeData(string.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
}
