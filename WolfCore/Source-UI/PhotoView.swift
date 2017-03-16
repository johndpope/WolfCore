//
//  PhotoView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/29/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

open class PhotoView: View {
    public private(set) var safeAreaView: PhotoSafeAreaView!

    public private(set) lazy var gradientView: GradientOverlayView = {
        let view = GradientOverlayView()
        view.alpha = 0.8
        return view
    }()

    public private(set) lazy var imageView: ImageView = {
        let view = ImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    open override func setup() {
        super.setup()
        isUserInteractionEnabled = false
        self => [
            imageView,
            gradientView
        ]
        imageView.constrainFrame()
        gradientView.constrainFrame()
        safeAreaView = PhotoSafeAreaView.addToView(view: self)
    }

    public var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
}
