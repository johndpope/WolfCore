//
//  ImageUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/2/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit
import CoreGraphics

public func imageWithSize(size: CGSize, opaque: Bool, scale: CGFloat, renderingMode: UIImageRenderingMode = .Automatic, drawing: (CGContext) -> Void) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    drawing(UIGraphicsGetCurrentContext()!)
    return UIGraphicsGetImageFromCurrentImageContext().imageWithRenderingMode(renderingMode)
}
