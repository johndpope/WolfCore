//
//  ScrollingStackView.swift
//  WolfCore
//
//  Created by Robert McNally on 6/30/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

//  keyboardAvoidantView: KeyboardAvoidantView
//      outerStackView: StackView
//          < your non-scrolling views above the scrolling view >
//          scrollView: ScrollView
//              stackView: StackView
//                  < your views that will scroll if necessary >
//          < your non-scrolling views below the scrolling view >

public class ScrollingStackView: View {
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
        view.indicatorStyle = .white
        view.keyboardDismissMode = .interactive
        return view
    }()

    public private(set) lazy var stackView: StackView = {
        let view = StackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()

    public override func setup() {
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
        addSubview(keyboardAvoidantView)
        activateConstraints(
            keyboardAvoidantView.leadingAnchor == leadingAnchor,
            keyboardAvoidantView.trailingAnchor == trailingAnchor,
            keyboardAvoidantView.topAnchor == topAnchor,
            keyboardAvoidantView.bottomAnchor == bottomAnchor =&= UILayoutPriorityDefaultHigh
        )
    }

    private func setupOuterStackView() {
        keyboardAvoidantView.addSubview(outerStackView)
        outerStackView.constrainToSuperview()
    }

    private func setupScrollView() {
        outerStackView.addArrangedSubview(scrollView)
    }

    private func setupStackView() {
        scrollView.addSubview(stackView)
        activateConstraints(
            stackView.leadingAnchor == leadingAnchor,
            stackView.trailingAnchor == trailingAnchor,

            stackView.leadingAnchor == scrollView.leadingAnchor,
            stackView.trailingAnchor == scrollView.trailingAnchor,
            stackView.topAnchor == scrollView.topAnchor,
            stackView.bottomAnchor == scrollView.bottomAnchor
        )
    }
}
