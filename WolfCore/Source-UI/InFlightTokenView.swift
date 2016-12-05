//
//  InFlightTokenView.swift
//  WolfCore
//
//  Created by Robert McNally on 5/26/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

class InFlightTokenView: View {
    static let viewHeight: CGFloat = 16

    private var idLabel: Label!
    private var nameLabel: Label!
    private var resultLabel: Label!

    var token: InFlightToken! {
        didSet {
            tokenChanged()
        }
    }

    func tokenChanged() {
        syncToToken()
    }

    private func createLabel() -> Label {
        let fontSize: CGFloat = 10

        let label = Label()
        label.makeTransparent(debugColor: .purple, debug: false)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.shadowColor = UIColor(white: 0.0, alpha: 0.5)
        label.shadowOffset = CGSize(width: 1.0, height: 1.0)

        return label
    }

    override func setup() {
        super.setup()
        makeTransparent(debugColor: .yellow, debug: false)
        transparentToTouches = true

        layer.cornerRadius = type(of: self).viewHeight / 2
        layer.borderWidth = 1.0

        idLabel = createLabel()
        idLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        addSubview(idLabel)

        activateConstraints(
            idLabel.leadingAnchor == leadingAnchor + 5,
            idLabel.centerYAnchor == centerYAnchor
        )

        nameLabel = createLabel() |> { (label: Label) -> Label in
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.7
            label.allowsDefaultTighteningForTruncation = true
            label.baselineAdjustment = .alignCenters
            label.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
            self.addSubview(label)

            activateConstraints(
                label.centerXAnchor == self.centerXAnchor =&= UILayoutPriorityDefaultHigh,
                label.centerYAnchor == self.centerYAnchor
            )

            return label
        }

        resultLabel = createLabel() |> { (label: Label) -> Label in
            label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
            self.addSubview(label)

            activateConstraints(
                label.trailingAnchor == self.trailingAnchor - 5,
                label.centerYAnchor == self.centerYAnchor
            )

            return label
        }

        activateConstraints(
            nameLabel.leadingAnchor >= idLabel.trailingAnchor + 5,
            nameLabel.trailingAnchor <= resultLabel.leadingAnchor - 5
        )
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: type(of: self).viewHeight)
    }

    private static let runningColor = UIColor.yellow
    private static let successColor = UIColor.green
    private static let failureColor = UIColor.red
    private static let canceledColor = UIColor.gray

    private func syncToToken() {
        guard let token = token else { return }

        idLabel.text = String(token.id)
        nameLabel.text = token.name
        var resultText: String?
        let color: UIColor
        if let result = token.result {
            if result.isSuccess {
                color = type(of: self).successColor
            } else if result.isCanceled {
                color = type(of: self).canceledColor
            } else {
                color = type(of: self).failureColor
            }
            if let code = result.code {
                resultText = "=\(code)"
            }
        } else {
            color = type(of: self).runningColor
        }

        backgroundColor = color.withAlphaComponent(0.4)
        layer.borderColor = color.withAlphaComponent(0.6).cgColor

        resultLabel.text = resultText
    }
}
