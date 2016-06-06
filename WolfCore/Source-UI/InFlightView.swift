//
//  InFlightView.swift
//  WolfCore
//
//  Created by Robert McNally on 5/26/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

private let animationDuration: NSTimeInterval = 0.3

public class InFlightView: View {
    private var columnsStackView: StackView!
    private var leftColumnView: View!
    private var rightColumnView: View!
    private var leftTokenViews = [InFlightTokenView]()
    private var rightTokenViews = [InFlightTokenView]()
    private var tokenViewsByID = [Int : InFlightTokenView]()
    private var tokenViewConstraintsByID = [Int: LayoutConstraintsGroup]()
    private var enteringTokenViews = [InFlightTokenView]()
    private var leavingTokenViews = [InFlightTokenView]()
    private var layoutCanceler: Canceler?
    private let serializer = Serializer()
    private let spacing: CGFloat = 2

    public override var hidden: Bool {
        didSet {
            if !hidden {
                layoutTokenViews(animated: false)
            }
        }
    }

    private var needsTokenViewLayout = false {
        didSet {
            guard !hidden else { return }

            if needsTokenViewLayout {
                if layoutCanceler == nil {
                    layoutCanceler = dispatchOnMain(afterDelay: 0.1) {
                        self.layoutCanceler = nil
                        self.layoutTokenViews(animated: true)
                    }
                }
            } else {
                layoutCanceler?.cancel()
                layoutCanceler = nil
            }
        }
    }

    public override func setup() {
        super.setup()
        makeTransparent(debugColor: .Red, debug: false)
        transparentToTouches = true
        inFlightTracker.didStart = didStart
        inFlightTracker.didEnd = didEnd

        setupColumnViews()
    }

    private func addView(forToken token: InFlightToken) {
        let tokenView = InFlightTokenView()

        serializer.dispatch {
            self.leftTokenViews.insert(tokenView, atIndex: 0)
            self.tokenViewsByID[token.id] = tokenView
            self.enteringTokenViews.append(tokenView)
        }

        self.addSubview(tokenView)
        tokenView.token = token
        self.layout(tokenView: tokenView, index: 0, referenceView: self.leftColumnView)
        tokenView.alpha = 0.0
        tokenView.setNeedsLayout()
        tokenView.layoutIfNeeded()
        self.needsTokenViewLayout = true
    }

    private func moveViewToRight(forToken token: InFlightToken) {
        guard let tokenView = self.tokenViewsByID[token.id] else { return }
        if let index = self.leftTokenViews.indexOf(tokenView) {
            serializer.dispatch {
                self.leftTokenViews.removeAtIndex(index)
                self.rightTokenViews.insert(tokenView, atIndex: 0)
            }
            self.needsTokenViewLayout = true
        }
        dispatchOnMain(afterDelay: 10.0) {
            self.removeView(forToken: token)
        }
    }

    private func updateView(forToken token: InFlightToken) {
        guard let tokenView = self.tokenViewsByID[token.id] else { return }
        tokenView.tokenChanged()
    }

    private func removeView(forToken token: InFlightToken) {
        guard let tokenView = self.tokenViewsByID[token.id] else { return }
        serializer.dispatch {
            self.leavingTokenViews.append(tokenView)
        }
        self.needsTokenViewLayout = true
    }

    private func layoutTokenViews(animated animated: Bool) {
        for tokenView in leavingTokenViews {
            dispatchAnimated(
                animated,
                duration: animationDuration,
                options: [.BeginFromCurrentState, .CurveEaseOut],
                animations: {
                    tokenView.alpha = 0.0
                },
                completion: { finished in
                    tokenView.removeFromSuperview()
                    self.tokenViewsByID.removeValueForKey(tokenView.token.id)
                    if let index = self.leftTokenViews.indexOf(tokenView) {
                        self.leftTokenViews.removeAtIndex(index)
                    }
                    if let index = self.rightTokenViews.indexOf(tokenView) {
                        self.rightTokenViews.removeAtIndex(index)
                    }
                    self.needsTokenViewLayout = true
                }
            )
        }

        for (index, tokenView) in leftTokenViews.enumerate() {
            layout(tokenView: tokenView, index: index, referenceView: leftColumnView)
        }

        for (index, tokenView) in rightTokenViews.enumerate() {
            layout(tokenView: tokenView, index: index, referenceView: rightColumnView)
        }

        for tokenView in enteringTokenViews {
            dispatchAnimated(
                animated,
                duration: animationDuration,
                delay: 0.0,
                options: [.BeginFromCurrentState, .CurveEaseOut],
                animations: {
                    tokenView.alpha = 1.0
                }
            )
        }
        enteringTokenViews.removeAll()

        setNeedsLayout()

        dispatchAnimated(
            animated,
            duration: animationDuration,
            delay: 0.0,
            options: [.BeginFromCurrentState, .CurveEaseOut],
            animations: {
                self.layoutIfNeeded()
            }
        )
    }

    private func layout(tokenView tokenView: InFlightTokenView, index: Int, referenceView: UIView) {
        let token = tokenView.token
        tokenViewConstraintsByID[token.id]?.active = false
        let viewY = CGFloat(index) * (InFlightTokenView.viewHeight + spacing)
        let constraints = [
            tokenView.leadingAnchor == referenceView.leadingAnchor,
            tokenView.trailingAnchor == referenceView.trailingAnchor,
            tokenView.topAnchor == referenceView.topAnchor + viewY,
            ]
        tokenViewConstraintsByID[token.id] = LayoutConstraintsGroup(constraints: constraints, active: true)
    }

    private func didStart(withToken token: InFlightToken) {
        dispatchOnMain {
            self.addView(forToken: token)
        }
    }

    private func didEnd(withToken token: InFlightToken) {
        dispatchOnMain {
            self.updateView(forToken: token)
            self.moveViewToRight(forToken: token)
        }
    }

    private func setupColumnViews() {
        leftColumnView = View()
        leftColumnView.makeTransparent(debugColor: .Red, debug: false)
        leftColumnView.transparentToTouches = true

        rightColumnView = View()
        rightColumnView.makeTransparent(debugColor: .Blue, debug: false)
        rightColumnView.transparentToTouches = true

        columnsStackView = StackView(arrangedSubviews: [leftColumnView, rightColumnView])
        columnsStackView.transparentToTouches = true
        columnsStackView.axis = .Horizontal
        columnsStackView.distribution = .FillEqually
        columnsStackView.alignment = .Fill
        columnsStackView.spacing = 20.0

        addSubview(columnsStackView)
        columnsStackView.constrainToSuperview(insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), identifier: "inFlightColumns")
    }
}
