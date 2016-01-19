//
//  ImageUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/2/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit
import CoreGraphics

public func imageWithSize(size: CGSize, opaque: Bool, scale: CGFloat, flipped: Bool = false, renderingMode: UIImageRenderingMode = .Automatic, drawing: (CGContext) -> Void) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    let context = UIGraphicsGetCurrentContext()!
    if flipped {
        CGContextTranslateCTM(context, 0.0, size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
    }
    drawing(context)
    return UIGraphicsGetImageFromCurrentImageContext().imageWithRenderingMode(renderingMode)
}
