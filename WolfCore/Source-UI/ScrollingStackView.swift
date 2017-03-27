//
//  ScrollingStackView.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/16.
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
    public let snapsToDetent: Bool
    private var showsDetentIndicator: Bool {
        return false // snapsToDetent
    }

    public init(hasKeyboardAvoidantView: Bool = true, axis: UILayoutConstraintAxis = .vertical, snapsToDetent: Bool = false) {
        self.hasKeyboardAvoidantView = hasKeyboardAvoidantView
        self.axis = axis
        self.snapsToDetent = snapsToDetent
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
        setupDetent()
    }

    public func flashScrollIndicators() {
        scrollView.flashScrollIndicators()
    }

    private func setupKeyboardAvoidantView() {
        guard hasKeyboardAvoidantView else { return }
        self => [
            keyboardAvoidantView
        ]
        activateConstraints(
            keyboardAvoidantView.leadingAnchor == leadingAnchor,
            keyboardAvoidantView.trailingAnchor == trailingAnchor,
            keyboardAvoidantView.topAnchor == topAnchor,
            keyboardAvoidantView.bottomAnchor == bottomAnchor =&= UILayoutPriorityRequired - 1
        )
    }

    private func setupOuterStackView() {
        if hasKeyboardAvoidantView {
            keyboardAvoidantView => [
                outerStackView
            ]
        } else {
            self => [
                outerStackView
            ]
        }
        outerStackView.constrainFrame()
    }

    private func setupScrollView() {
        outerStackView => [
            scrollView
        ]
        if axis == .horizontal {
            scrollView.scrollsToTop = false
        }
        scrollView.delegate = self
    }

    private func setupStackView() {
        scrollView => [
            stackView
        ]
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

    lazy var detentIndicatorView: View = {
        let view = View()
        view.backgroundColor = .red
        switch self.axis {
        case .horizontal:
            view.constrainSize(to: CGSize(width: 1, height: 10))
        case .vertical:
            view.constrainSize(to: CGSize(width: 10, height: 1))
        }
        return view
    }()

    var detentIndicatorPositionConstraint: NSLayoutConstraint?

    func setupDetent() {
        guard showsDetentIndicator else { return }

        self => [
            detentIndicatorView
        ]
        switch axis {
        case .horizontal:
            activateConstraints(
                detentIndicatorView.bottomAnchor == bottomAnchor
            )
        case .vertical:
            activateConstraints(
                detentIndicatorView.leadingAnchor == leadingAnchor
            )
        }
        syncDetentIndicator()
    }

    var detentPosition: CGFloat = 0.0 {
        didSet {
            syncDetentIndicator()
        }
    }

    func syncDetentIndicator() {
        guard showsDetentIndicator else { return }
        switch axis {
        case .horizontal:
            replaceConstraint(&detentIndicatorPositionConstraint, with: detentIndicatorView.centerXAnchor == leadingAnchor + detentPosition)
        case .vertical:
            replaceConstraint(&detentIndicatorPositionConstraint, with: detentIndicatorView.centerYAnchor == topAnchor + detentPosition)
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard snapsToDetent else { return }
        switch axis {
        case .horizontal:
            detentPosition = bounds.width / 2
        case .vertical:
            detentPosition = bounds.height / 2
        }
    }
}

extension ScrollingStackView: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard snapsToDetent else { return }

        let spacing = stackView.spacing
        let views = stackView.arrangedSubviews
        for (index, view) in views.enumerated() {
            let isFirst = index == 0
            let isLast = index == views.count - 1

            switch axis {
            case .horizontal:
                let viewMin = isFirst ? -CGFloat.infinity : view.frame.minX - spacing / 2
                let viewMax = isLast ? CGFloat.infinity : view.frame.maxX + spacing / 2
                let range = viewMin...viewMax
                if range.contains(targetContentOffset.pointee.x + detentPosition) {
                    targetContentOffset.pointee.x = view.frame.midX - detentPosition
                    break
                }
            case .vertical:
                let viewMin = isFirst ? -CGFloat.infinity : view.frame.minY - spacing / 2
                let viewMax = isLast ? CGFloat.infinity : view.frame.maxY + spacing / 2
                let range = viewMin...viewMax
                if range.contains(targetContentOffset.pointee.y + detentPosition) {
                    targetContentOffset.pointee.y = view.frame.midY - detentPosition
                    break
                }
            }
        }
    }
}
