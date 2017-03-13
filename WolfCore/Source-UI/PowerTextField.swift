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
    public var text: String? {
        get {
            return textField.text
        }

        set {
            textField.text = newValue
        }
    }

    private lazy var verticalStackView: VerticalStackView = {
        let view = VerticalStackView()
        return view
    }()

    private lazy var containerView: View = {
        let view = View()
        return view
    }()

    private lazy var horizontalStackView: HorizontalStackView = {
        let view = HorizontalStackView()
        return view
    }()

    private lazy var characterCountLabel: Label = {
        let label = Label()
        return label
    }()

    private lazy var textField: TextField = {
        let field = TextField()
        return field
    }()

    private lazy var iconView: ImageView = {
        let view = ImageView()
        return view
    }()

    public override var isDebug: Bool {
        didSet {
            containerView.isDebug = isDebug
            characterCountLabel.isDebug = isDebug
            textField.isDebug = isDebug
            iconView.isDebug = isDebug
        }
    }

    public override func setup() {
        super.setup()

        addSubview(verticalStackView)
        verticalStackView.addArrangedSubviews([containerView, characterCountLabel])
        containerView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubviews([iconView, textField])

        iconView.image = #imageLiteral(resourceName: "facebook18")
        textField.text = "Text"
        characterCountLabel.text = "0/100"

        isDebug = true
    }
}
