//
//  GradientOverlayView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/29/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class GradientOverlayView: View {
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    private var colors = [UIColor.red.cgColor, UIColor.blue.cgColor]

    public var startColor: UIColor {
        get { return UIColor(cgColor: colors[0]) }

        set {
            colors[0] = newValue.cgColor
            gradientLayer.colors = colors
        }
    }

    public var endColor: UIColor {
        get { return UIColor(cgColor: colors[1]) }

        set {
            colors[1] = newValue.cgColor
            gradientLayer.colors = colors
        }
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
