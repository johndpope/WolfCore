//
//  MessageBulletinView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/20/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class MessageBulletinView: View {
    private let bulletin: MessageBulletin

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
        label.fontStyleName = .bulletinTitle
        return label
    }()

    private lazy var messageLabel: Label = {
        let label = Label()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.fontStyleName = .bulletinMessage
        return label
    }()

    public init(bulletin: MessageBulletin) {
        self.bulletin = bulletin
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func setup() {
        super.setup()

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
        guard let skin = skin else { return }

        contentView.backgroundColor = skin.bulletinBackgroundColor
    }

    private func setupTitle() {
        guard let title = bulletin.title else { return }
        stackView => [
            titleLabel
        ]
        titleLabel.text = title
    }

    private func setupMessage() {
        guard let message = bulletin.message else { return }
        stackView => [
            messageLabel
        ]
        messageLabel.text = message
    }
}
