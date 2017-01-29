//
//  PhotoBackgroundView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/29/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class PhotoBackgroundView: View {
    public private(set) var safeAreaView: PhotoSafeAreaView!

    public private(set) lazy var gradientView: GradientOverlayView = {
        let view = GradientOverlayView()
        view.alpha = 0.8
        return view
    }()

    private lazy var imageView: ImageView = {
        let view = ImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    public override func setup() {
        super.setup()
        addSubview(imageView)
        imageView.constrainToSuperview()
        addSubview(gradientView)
        gradientView.constrainToSuperview()
        safeAreaView = PhotoSafeAreaView.addToView(view: self)
    }

    public var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
}
