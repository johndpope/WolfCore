//
//  GradientOverlayView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/29/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

open class GradientOverlayView: View {
    open override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    public var colorFracs: [ColorFrac]! {
        didSet {
            syncColors()
        }
    }

    private func syncColors() {
        var colors = [CGColor]()
        var locations = [NSNumber]()
        colorFracs.forEach { (color, frac) in
            colors.append(color.cgColor)
            locations.append(NSNumber(value: Double(frac)))
        }
        gradientLayer.colors = colors
        gradientLayer.locations = locations
    }

    public var startPoint: CGPoint {
        get { return gradientLayer.startPoint }
        set { gradientLayer.startPoint = newValue }
    }

    public var endPoint: CGPoint {
        get { return gradientLayer.endPoint }
        set { gradientLayer.endPoint = newValue }
    }
}
