//
//  FlexView.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/14/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class FlexView: View {
    public enum Content {
        case string(String)
        case image(UIImage)
    }

    public var content: Content? {
        didSet {
            sync()
        }
    }

    public private(set) var label: Label!
    public private(set) var imageView: ImageView!
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
        addSubview(view)
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
        case nil:
            break
        }
    }
}
