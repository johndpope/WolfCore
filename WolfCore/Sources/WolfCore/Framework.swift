//
//  Framework.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/29/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public class Framework {
    public static var bundle: Bundle { return Bundle.findBundle(forClass: self) }
}
