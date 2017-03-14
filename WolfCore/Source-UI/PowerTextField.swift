//
//  PowerTextField.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/12/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class PowerTextField: View {
    public var characterLimit: Int?
    public var showsCharacterCount: Bool = false {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    public var numberOfLines: Int = 1
    public var icon: UIImage? {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    public var text: String? {
        get {
            return textView.text
        }

        set {
            textView.text = newValue
        }
    }

    public var placeholder: String? {
        get {
            return placeholderLabel.text
        }

        set {
            placeholderLabel.text = newValue
        }
    }

    private lazy var verticalStackView: VerticalStackView = {
        let view = VerticalStackView()
        view.alignment = .leading
        return view
    }()

    private lazy var frameView: View = {
        let view = View()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()

    private lazy var horizontalStackView: HorizontalStackView = {
        let view = HorizontalStackView()
        view.spacing = 6
        view.alignment = .center
        return view
    }()

    private lazy var characterCountLabel: Label = {
        let label = Label()
        return label
    }()

    private lazy var placeholderLabel: Label = {
        let label = Label()
        return label
    }()

    private lazy var textView: TextView = {
        let view = TextView()
        view.contentInset = .zero
        view.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: -4)
        return view
    }()

    private lazy var iconView: ImageView = {
        let view = ImageView()
        view.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return view
    }()

    public override var isDebug: Bool {
        didSet {
            frameView.isDebug = isDebug
            characterCountLabel.isDebug = isDebug
            textView.isDebug = isDebug
            iconView.isDebug = isDebug

            frameView.debugBackgroundColor = debugBackgroundColor
            characterCountLabel.debugBackgroundColor = debugBackgroundColor
            textView.debugBackgroundColor = debugBackgroundColor
            iconView.debugBackgroundColor = debugBackgroundColor
        }
    }

    public override func setup() {
        super.setup()

        self => {[
            verticalStackView => {[
                frameView => {
                    horizontalStackView => {[
                        iconView,
                        textView
                        ]}
                },
                characterCountLabel
                ]},
            placeholderLabel
        ]}

        constrainWidth(to: 200)
        activateConstraint(frameView.widthAnchor == verticalStackView.widthAnchor)
        verticalStackView.constrainFrame()
        horizontalStackView.constrainFrame(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        textViewHeightConstraint = textView.constrainHeight(to: 20)
        activateConstraints(
            placeholderLabel.leadingAnchor == textView.leadingAnchor,
            placeholderLabel.trailingAnchor == textView.trailingAnchor,
            placeholderLabel.topAnchor == textView.topAnchor
            )

        //textView.text = "Something Fun"
        placeholderLabel.text = "Placeholder"
        characterCountLabel.text = "0/100"
    }

    private var textViewHeightConstraint: NSLayoutConstraint!

    private var lineHeight: CGFloat {
        return textView.font?.lineHeight ?? 20
    }

    public override func updateConstraints() {
        super.updateConstraints()

        syncToIcon()
        syncToShowsCharacterCount()
        syncToFont()
    }

    public override func updateAppearance(skin: Skin?) {
        super.updateAppearance(skin: skin)
        textView.fontStyleName = .textFieldContent
        characterCountLabel.fontStyleName = .textFieldCounter
        placeholderLabel.fontStyleName = .textFieldPlaceholder
        syncToFont()
    }

    private func syncToIcon() {
        if let icon = icon {
            iconView.image = icon
            iconView.show()
        } else {
            iconView.hide()
        }
    }

    private func syncToShowsCharacterCount() {
        switch showsCharacterCount {
        case false:
            characterCountLabel.hide()
        case true:
            characterCountLabel.show()
        }
    }

    private func syncToFont() {
        textViewHeightConstraint.constant = ceil(lineHeight * CGFloat(numberOfLines))
    }
}
