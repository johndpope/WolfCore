//
//  PlaceholderView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/30/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

open class PlaceholderView: View {
    private var titleLabel: Label = {
        let label = Label()
        label.text = "Title"
        return label
    }()
    public private(set) lazy var gestureActions: ViewGestureActions = {
        return ViewGestureActions(view: self)
    }()

    private var heightConstraint: NSLayoutConstraint?

    @IBInspectable public var title: String! {
        didSet {
            syncTitle()
        }
    }

    @IBInspectable public var fontStyle: String? {
        didSet {
            syncTitle()
        }
    }

    public var height: CGFloat! {
        didSet {
            syncHeight()
        }
    }

    public var fontStyleName: FontStyleName? {
        didSet {
            syncTitle()
        }
    }

    private func syncTitle() {
        titleLabel.fontStyleName = fontStyleName ?? FontStyleName(fontStyle)
        titleLabel.text = title
    }

    private func syncHeight() {
        replaceConstraint(&heightConstraint, with: heightAnchor == height)
    }

    public init(title: String, fontStyleName: FontStyleName? = nil, height: CGFloat, backgroundColor: UIColor = .clear) {
        super.init(frame: .zero)
        self.title = title
        self.fontStyleName = fontStyleName
        self.height = height
        self.backgroundColor = backgroundColor
        syncTitle()
        syncHeight()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func setup() {
        super.setup()
        isOpaque = false
        addSubview(titleLabel)
        titleLabel.constrainCenterToCenterOfSuperview()
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawPlaceholderRect(rect)
    }
}
