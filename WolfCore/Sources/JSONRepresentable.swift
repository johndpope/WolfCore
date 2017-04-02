//
//  JSONRepresentable.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/1/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public protocol JSONRepresentable {
    associatedtype JSONValue
    var jsonRepresentation: JSONValue { get }
}

extension Int: JSONRepresentable {
    public var jsonRepresentation: Int { return self }
}

extension Double: JSONRepresentable {
    public var jsonRepresentation: Double { return self }
}

extension Float: JSONRepresentable {
    public var jsonRepresentation: Double { return Double(self) }
}

extension CGFloat: JSONRepresentable {
    public var jsonRepresentation: Double { return Double(self) }
}

extension Bool: JSONRepresentable {
    public var jsonRepresentation: Bool { return self }
}

extension String: JSONRepresentable {
    public var jsonRepresentation: String { return self }
}

extension JSON: JSONRepresentable {
    public var jsonRepresentation: JSON.Value { return self.value }
}

extension URL: JSONRepresentable {
    public var jsonRepresentation: String { return self.absoluteString }
}

extension Date: JSONRepresentable {
    public var jsonRepresentation: String { return self.iso8601 }
}
