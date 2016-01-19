//
//  ImageExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

extension UIImage {
    public func tintWithColor(color: UIColor) -> UIImage {
        return imageWithSize(self.size, opaque: false, scale: self.scale, renderingMode: .AlwaysOriginal) { context in
            let bounds = CGRect(origin: CGPoint.zero, size: self.size)
            self.drawInRect(bounds)
            color.set()
            UIRectFillUsingBlendMode(bounds, .SourceAtop)
        }
    }
    
    public convenience init?(named name: String, fromBundleForClass aClass: AnyClass, compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) {
        let bundle = NSBundle.findBundle(forClass: aClass)
        self.init(named: name, inBundle: bundle, compatibleWithTraitCollection: traitCollection)
    }
}
