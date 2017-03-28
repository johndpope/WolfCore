//
//  ObjectAliaser.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/18/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation
#if os(iOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
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
        let joiner = Joiner(left: "(", right: ")")

        joiner.append("0x\(String(alias(forObject: object), radix: 16).paddedWithZeros(to: 2))")

        var id: String?
        var className: String? = NSStringFromClass(type(of: object))
        #if os(iOS) || os(tvOS)
            switch object {
            case let view as UIView:
                if let accessibilityIdentifier = view.accessibilityIdentifier {
                    id = "\"\(accessibilityIdentifier)\""
                }

            case let barItem as UIBarItem:
                id = "\"\(barItem.accessibilityIdentifier†)\""

            case let image as UIImage:
                id = "\"\(image.accessibilityIdentifier†)\""

            default:
                break
            }
        #endif

        switch object {

        case let color as OSColor:
            className = "Color"
            id = color.debugSummary

        case let font as OSFont:
            className = "Font"
            id = getID(forFont: font)

        case let number as NSNumber:
            className = nil
            id = getID(forNumber: number)

        case let layoutConstraint as NSLayoutConstraint:
            if let identifier = layoutConstraint.identifier {
                id = "\"\(identifier)\""
            }
            if type(of: layoutConstraint) == NSLayoutConstraint.self {
                className = nil
            }

        default:
            break
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
            return number as! Bool ? "true" : "false"
        } else {
            return String(describing: number)
        }
    }

    private func getID(forFont font: OSFont) -> String {
        let idJoiner = Joiner()
        idJoiner.append("\"\(font.familyName)\"")
        if font.isBold {
            idJoiner.append("bold")
        }
        if font.isItalic {
            idJoiner.append("italic")
        }
        idJoiner.append(font.pointSize)
        return idJoiner.description
    }
}
