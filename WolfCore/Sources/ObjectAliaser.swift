//
//  ObjectAliaser.swift
//  WolfCore
//
//  Created by Robert McNally on 5/18/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation
#if os(iOS)
    import UIKit
#endif

/// Creates short, unique, descriptive names for a set of related objects.
public class ObjectAliaser {
    private var aliases = [ObjectIdentifier: Int]()
    private var nextAlias = 0

    func alias(forObject object: AnyObject) -> Int {
        let objectIdentifier = ObjectIdentifier(object)
        var alias: Int! = aliases[objectIdentifier]
        if alias == nil {
            alias = nextAlias
            aliases[objectIdentifier] = nextAlias
            nextAlias = nextAlias + 1
        }
        return alias
    }

    // swiftlint:disable cyclomatic_complexity

    func name(forObject object: AnyObject) -> String {
        let joiner = Joiner("(", ")", " ")

        joiner.append("0x\(String(alias(forObject: object), radix: 16).padded(toCount: 2, withCharacter: "0"))")

        var id: String?
        var className: String? = NSStringFromClass(object.dynamicType)
        if let view = object as? UIView {
            if let accessibilityIdentifier = view.accessibilityIdentifier {
                id = "\"\(accessibilityIdentifier)\""
            }
        } else if let barItem = object as? UIBarItem {
            id = "\"\(barItem.accessibilityIdentifier)\""
        } else if let image = object as? UIImage {
            id = "\"\(image.accessibilityIdentifier)\""
        } else if let number = object as? NSNumber {
            className = nil
            id = getID(forNumber: number)
        } else if let font = object as? UIFont {
            className = "Font"
            id = getID(forFont: font)
        } else if let color = object as? UIColor {
            className = "Color"
            id = color.debugSummary
        } else if let layoutConstraint = object as? NSLayoutConstraint {
            if let identifier = layoutConstraint.identifier {
                id = "\"\(identifier)\""
            }
            if layoutConstraint.dynamicType == NSLayoutConstraint.self {
                className = nil
            }
        }

        if let className = className {
            joiner.append(className)
        }

        if let id = id {
            joiner.append(id)
        }

        return joiner.description
    }

    // swiftlint:enable cyclomatic_complexity

    private func getID(forNumber number: NSNumber) -> String {
        if CFGetTypeID(number) == CFBooleanGetTypeID() {
            return number as Bool ? "true" : "false"
        } else {
            return String(number)
        }
    }

    private func getID(forFont font: UIFont) -> String {
        let idJoiner = Joiner("", "", " ")
        idJoiner.append("\"\(font.familyName)\"")
        let traits = font.fontDescriptor().symbolicTraits
        if traits.contains(.TraitBold) {
            idJoiner.append("bold")
        }
        if traits.contains(.TraitItalic) {
            idJoiner.append("italic")
        }
        idJoiner.append(font.pointSize)
        return idJoiner.description
    }
}
