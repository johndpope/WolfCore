//
//  FontDebugging.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/25/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public func printFontNames() {
    for family in UIFont.familyNames {
        print("")
        print("\(family)")
        for fontName in UIFont.fontNames(forFamilyName: family) {
            print("\t\(fontName)")
        }
    }
}
