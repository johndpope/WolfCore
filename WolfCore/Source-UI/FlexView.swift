//
//  FlexView.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/14/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public enum FlexContent {
    case string(String)
    case image(UIImage)
    case imageString(UIImage, String)
}

public class FlexView: View {
    public var content: FlexContent? {
        didSet {
            sync()
        }
    }

    private var horizontalStackView: HorizontalStackView = {
        let view = HorizontalStackView()
        return view
    }()

    private var label: Label!
    private var imageView: ImageView!
    private var imageLabelView: View!

    public init() {
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func setup() {
        super.setup()
        isUserInteractionEnabled = false
        self => [
            horizontalStackView
        ]
        horizontalStackView.constrainFrame()
        horizontalStackView.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    }

    private func setContentViews(_ views: [UIView]) {
        horizontalStackView.removeAllSubviews()
        horizontalStackView => views
    }

    private func sync() {
        switch content {
        case .string(let text)?:
            let label = Label()
            label.text = text
            setContentViews([label])
        case .image(let image)?:
            let imageView = ImageView()
            imageView.image = image
            setContentViews([imageView])
        case .imageString(let image, let string)?:
            let label = Label()
            let imageView = ImageView()
            label.text = string
            imageView.image = image
            setContentViews([imageView, label])
        case nil:
            break
        }
    }
}
