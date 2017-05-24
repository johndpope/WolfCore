//
//  BannerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/20/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class BannerView: View {
    private let title: String?
    private let message: String?
    private let foregroundColor: UIColor
    private let contentBackgroundColor: UIColor

    private lazy var contentView: View = {
        let view = View()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()

    private lazy var stackView: VerticalStackView = {
        let view = VerticalStackView()
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()

    private lazy var titleLabel: Label = {
        let label = Label()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private lazy var messageLabel: Label = {
        let label = Label()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    public init(title: String?, message: String?, foregroundColor: UIColor = .black, backgroundColor: UIColor = .white) {
        self.title = title
        self.message = message
        self.foregroundColor = foregroundColor
        self.contentBackgroundColor = backgroundColor
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func setup() {
        super.setup()

//        constrainHeight(to: 44)

        setupContentView()
        setupStackView()
        setupTitle()
        setupMessage()
    }

    private func setupContentView() {
        self => [
            contentView
        ]

        contentView.constrainFrame(insets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
    }

    private func setupStackView() {
        contentView => [
            stackView
        ]

        activateConstraints(
            stackView.centerYAnchor == contentView.centerYAnchor,
            stackView.heightAnchor == contentView.heightAnchor - 16,
            stackView.leadingAnchor == contentView.leadingAnchor + 20,
            stackView.trailingAnchor == contentView.trailingAnchor - 20
        )
    }

    public override func didMoveToSuperview() {
        guard superview != nil else { return }
        propagateSkin(why: "movedToSuperview")
    }

    public override func updateAppearance(skin: Skin?) {
        super.updateAppearance(skin: skin)

        contentView.backgroundColor = contentBackgroundColor

        if title != nil {
            titleLabel.textColor = foregroundColor
            titleLabel.font = .boldSystemFont(ofSize: 10)
        }

        if message != nil {
            messageLabel.font = .systemFont(ofSize: 10)
            messageLabel.textColor = foregroundColor
        }
    }

    private func setupTitle() {
        guard let title = title else { return }
        stackView => [
            titleLabel
        ]
        titleLabel.text = title
    }

    private func setupMessage() {
        guard let message = message else { return }
        stackView => [
            messageLabel
        ]
        messageLabel.text = message
    }
}
