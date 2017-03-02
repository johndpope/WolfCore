//
//  CoreImageFilters.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/28/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

public class CoreImageFilter {
    let filter: CIFilter

    public init(filterName: String) { filter = CIFilter(name: filterName)! }

    public var input: CIImage {
        get { return filter.value(forKey: kCIInputImageKey) as! CIImage }
        set { filter.setValue(newValue, forKey: kCIInputImageKey) }
    }

    public var output: CIImage {
        return filter.outputImage!
    }

    public var inputImage: UIImage {
        get { fatalError() }
        set { input = CIImage(image: newValue)! }
    }

    public func outputImage(withOrientation orientation: UIImageOrientation, scale: CGFloat) -> UIImage {
        let context = CIContext()
        let cgImage = context.createCGImage(output, from: output.extent)!
        return UIImage(cgImage: cgImage, scale: scale, orientation: orientation)
    }
}

public class ColorControlsFilter: CoreImageFilter {
    public init() { super.init(filterName: "CIColorControls") }

    public convenience init(saturation: Double = 1.0, brightness: Double = 0.0, contrast: Double = 1.0) {
        self.init()
        self.saturation = saturation
        self.brightness = brightness
        self.contrast = contrast
    }

    public var saturation: Double {
        get { return filter.value(forKey: kCIInputSaturationKey) as? Double ?? 1.0 }
        set { filter.setValue(newValue, forKey: kCIInputSaturationKey) }
    }

    public var brightness: Double {
        get { return filter.value(forKey: kCIInputBrightnessKey) as? Double ?? 0.0 }
        set { filter.setValue(newValue, forKey: kCIInputBrightnessKey) }
    }

    public var contrast: Double {
        get { return filter.value(forKey: kCIInputContrastKey) as? Double ?? 1.0 }
        set { filter.setValue(newValue, forKey: kCIInputContrastKey) }
    }
}

public class ExposureAdjustFilter: CoreImageFilter {
    public init() { super.init(filterName: "CIExposureAdjust") }

    public convenience init(ev: Double = 0.5) {
        self.init()
        self.ev = ev
    }

    public var ev: Double {
        get { return filter.value(forKey: kCIInputEVKey) as? Double ?? 0.5 }
        set { filter.setValue(newValue, forKey: kCIInputEVKey) }
    }
}

public class BlurFilter: CoreImageFilter {
    public init() { super.init(filterName: "CIBoxBlur") }

    public convenience init(radius: Double = 1.0) {
        self.init()
        self.radius = radius
    }

    public var radius: Double {
        get { return filter.value(forKey: kCIInputRadiusKey) as? Double ?? 10.0 }
        set { filter.setValue(newValue, forKey: kCIInputRadiusKey) }
    }
}

public class GaussianBlurFilter: CoreImageFilter {
    public init() { super.init(filterName: "CIGaussianBlur") }

    public convenience init(radius: Double = 1.0) {
        self.init()
        self.radius = radius
    }
    
    public var radius: Double {
        get { return filter.value(forKey: kCIInputRadiusKey) as? Double ?? 10.0 }
        set { filter.setValue(newValue, forKey: kCIInputRadiusKey) }
    }
}

public func |> (lhs: UIImage, rhs: CoreImageFilter) -> CoreImageFilter {
    rhs.inputImage = lhs
    return rhs
}

public func |> (lhs: CoreImageFilter, rhs: CoreImageFilter) -> CoreImageFilter {
    rhs.input = lhs.output
    return rhs
}

public func |> (lhs: CoreImageFilter, rhs: (orientation: UIImageOrientation, scale: CGFloat)) -> UIImage {
    return lhs.outputImage(withOrientation: rhs.orientation, scale: rhs.scale)
}
