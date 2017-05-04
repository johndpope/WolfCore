//
//  FlexView.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/14/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public struct FlexImageLabel {
    var image: UIImage
    var string: String
    public init(image: UIImage, string: String) {
        self.image = image
        self.string = string
    }
}

public enum FlexContent {
    case string(String)
    case image(UIImage)
    case imageLabel(FlexImageLabel)
}

public class FlexView: View {
    public var content: FlexContent? {
        didSet {
            sync()
        }
    }

    public private(set) var label: Label!
    public private(set) var imageView: ImageView!
    public private(set) var imageLabelView: View!
    public private(set) var contentView: UIView!

    public init() {
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func setup() {
        super.setup()
        isUserInteractionEnabled = false
    }

    private func removeContentView() {
        guard let contentView = contentView else { return }
        contentView.removeFromSuperview()
        self.contentView = nil
    }

    private func setContentView(_ view: UIView) {
        self => [
            view
        ]
        view.constrainFrame()
        view.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    }

    private func sync() {
        removeContentView()
        switch content {
        case .string(let text)?:
            label = Label()
            setContentView(label)
            label.text = text
        case .image(let image)?:
            imageView = ImageView()
            setContentView(imageView)
            imageView.image = image
        case .imageLabel(let imageLabel)?:
            self.imageLabelView = View()
            label = Label()
            imageView = ImageView()
            let imageLabel = FlexImageLabel(image: imageLabel.image, string: imageLabel.string)
            label.text = imageLabel.string
            imageView.image = imageLabel.image
            self.imageLabelView => [
                HorizontalStackView() => [
                    label,
                    imageView
                ]
            ]
            setContentView(self.imageLabelView)
        case nil:
            break
        }
    }
}
