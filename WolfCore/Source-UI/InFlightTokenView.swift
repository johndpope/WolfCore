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
        label.makeTransparent(debugColor: .Purple, debug: false)
        label.textColor = .White
        label.font = UIFont.systemFontOfSize(fontSize)
        label.shadowColor = UIColor(white: 0.0, alpha: 0.5)
        label.shadowOffset = CGSize(width: 1.0, height: 1.0)

        return label
    }

    override func setup() {
        super.setup()
        makeTransparent(debugColor: .Yellow, debug: false)
        transparentToTouches = true

        layer.cornerRadius = self.dynamicType.viewHeight / 2
        layer.borderWidth = 1.0

        idLabel = createLabel()
        idLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        addSubview(idLabel)

        activateConstraints(
            idLabel.leadingAnchor == leadingAnchor + 5,
            idLabel.centerYAnchor == centerYAnchor
        )

        nameLabel = createLabel()
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.7
        nameLabel.allowsDefaultTighteningForTruncation = true
        nameLabel.baselineAdjustment = .AlignCenters
        nameLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        addSubview(nameLabel)

        activateConstraints(
            nameLabel.centerXAnchor == centerXAnchor =&= UILayoutPriorityDefaultHigh,
            nameLabel.centerYAnchor == centerYAnchor
        )

        resultLabel = createLabel()
        resultLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        addSubview(resultLabel)

        activateConstraints(
            resultLabel.trailingAnchor == trailingAnchor - 5,
            resultLabel.centerYAnchor == centerYAnchor
        )

        activateConstraints(
            nameLabel.leadingAnchor >= idLabel.trailingAnchor + 5,
            nameLabel.trailingAnchor <= resultLabel.leadingAnchor - 5
        )
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: self.dynamicType.viewHeight)
    }

    private static let runningColor = UIColor.Yellow
    private static let successColor = UIColor.Green
    private static let failureColor = UIColor.Red

    private func syncToToken() {
        guard let token = token else { return }

        idLabel.text = String(token.id)
        nameLabel.text = token.name
        var resultText: String?
        let color: UIColor
        if let result = token.result {
            color = result.isSuccess ? self.dynamicType.successColor : self.dynamicType.failureColor
            if let code = result.code {
                resultText = "=\(code)"
            }
        } else {
            color = self.dynamicType.runningColor
        }

        backgroundColor = color.colorWithAlphaComponent(0.4)
        layer.borderColor = color.colorWithAlphaComponent(0.6).CGColor

        resultLabel.text = resultText
    }
}
