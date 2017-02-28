//
//  ScrollingStackView.swift
//  WolfCore
//
//  Created by Robert McNally on 6/30/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

//  keyboardAvoidantView: KeyboardAvoidantView (optional)
//      outerStackView: StackView
//          < your non-scrolling views above the scrolling view >
//          scrollView: ScrollView
//              stackView: StackView
//                  < your views that will scroll if necessary >
//          < your non-scrolling views below the scrolling view >

open class ScrollingStackView: View {
    public let hasKeyboardAvoidantView: Bool
    public let axis: UILayoutConstraintAxis

    public init(hasKeyboardAvoidantView: Bool = true, axis: UILayoutConstraintAxis = .vertical) {
        self.hasKeyboardAvoidantView = hasKeyboardAvoidantView
        self.axis = axis
        super.init(frame: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public private(set) lazy var keyboardAvoidantView: KeyboardAvoidantView = {
        let view = KeyboardAvoidantView()
        return view
    }()

    public private(set) lazy var outerStackView: StackView = {
        let view = StackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()

    public private(set) lazy var scrollView: ScrollView = {
        let view = ScrollView()
        view.keyboardDismissMode = .interactive
        return view
    }()

    public private(set) lazy var stackView: StackView = {
        let view = StackView()
        view.axis = self.axis
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()

    open override func setup() {
        super.setup()
        setupKeyboardAvoidantView()
        setupOuterStackView()
        setupScrollView()
        setupStackView()
    }

    public func flashScrollIndicators() {
        scrollView.flashScrollIndicators()
    }

    private func setupKeyboardAvoidantView() {
        guard hasKeyboardAvoidantView else { return }
        addSubview(keyboardAvoidantView)
        activateConstraints(
            keyboardAvoidantView.leadingAnchor == leadingAnchor,
            keyboardAvoidantView.trailingAnchor == trailingAnchor,
            keyboardAvoidantView.topAnchor == topAnchor,
            keyboardAvoidantView.bottomAnchor == bottomAnchor =&= UILayoutPriorityRequired - 1
        )
    }

    private func setupOuterStackView() {
        if hasKeyboardAvoidantView {
            keyboardAvoidantView.addSubview(outerStackView)
        } else {
            addSubview(outerStackView)
        }
        outerStackView.constrainFrame()
    }

    private func setupScrollView() {
        outerStackView.addArrangedSubview(scrollView)
    }

    private func setupStackView() {
        scrollView.addSubview(stackView)
        switch axis {
        case .vertical:
            activateConstraints(
                stackView.leadingAnchor == leadingAnchor,
                stackView.trailingAnchor == trailingAnchor
            )
        case .horizontal:
            activateConstraints(
                stackView.topAnchor == topAnchor,
                stackView.bottomAnchor == bottomAnchor
            )
        }

        activateConstraints(
            stackView.leadingAnchor == scrollView.leadingAnchor,
            stackView.trailingAnchor == scrollView.trailingAnchor,
            stackView.topAnchor == scrollView.topAnchor,
            stackView.bottomAnchor == scrollView.bottomAnchor
        )
    }
}
