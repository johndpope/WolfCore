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
    
    func name(forObject object: AnyObject) -> String {
        let joiner = Joiner("(", ")", " ")
        
        joiner.append("0x\(String(alias(forObject: object), radix: 16).padded(toCount: 2, withCharacter: "0"))")
        
        joiner.append(NSStringFromClass(object.dynamicType))
        
        #if os(iOS)
            var id: String?
            if let view = object as? UIView {
                id = view.accessibilityIdentifier
            } else if let barItem = object as? UIBarItem {
                id = barItem.accessibilityIdentifier
            } else if let image = object as? UIImage {
                id = image.accessibilityIdentifier
            }
            if let id = id {
                joiner.append("\"\(id)\"")
            }
        #endif
        
        return joiner.description
    }
}
