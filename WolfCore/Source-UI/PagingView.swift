//
//  PagingView.swift
//  WolfCore
//
//  Created by Robert McNally on 5/17/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

class PagingContentView: View { }

open class PagingView: View {
    public typealias IndexDispatchBlock = (Int) -> Void

    public var debug = false

    public var arrangedViewAtIndexDidBecomeVisible: IndexDispatchBlock?
    public var arrangedViewAtIndexDidBecomeInvisible: IndexDispatchBlock?
    public var onWillBeginDragging: Block?
    public var onDidEndDragging: Block?
    public var onDidLayout: ((_ fromIndex: Int, _ toIndex: Int, _ frac: Frac) -> Void)?
    public private(set) var scrollingFromIndex: Int = 0
    public private(set) var scrollingToIndex: Int = 0
    public private(set) var scrollingFrac: Frac = 0.0
    public private(set) var pageControl: PageControl!

    private var scrollView: ScrollView!
    private var contentView: PagingContentView!
    private var contentWidthConstraint: NSLayoutConstraint!
    private var pageControlBottomConstraint: NSLayoutConstraint!
    private var arrangedViewsLeadingConstraints = [NSLayoutConstraint]()
    private var slotsCount: Int = 0

    public var bottomView: UIView! {
        willSet {
            bottomView?.removeFromSuperview()
        }

        didSet {
        }
    }

    private var visibleViewIndexes = Set<Int>() {
        willSet {
            let added = newValue.subtracting(visibleViewIndexes)
            let removed = visibleViewIndexes.subtracting(newValue)
            for index in added {
                arrangedViewAtIndexDidBecomeVisible?(index)
            }
            for index in removed {
                arrangedViewAtIndexDidBecomeInvisible?(index)
            }
        }
    }

    public var isCircular = false {
        didSet {
            syncSlots()
        }
    }

    public func setPageControl(isHidden: Bool, animated: Bool = true) {
        guard pageControl.isHidden != isHidden else {
            return
        }

        pageControl.isHidden = false

        dispatchAnimated(
            animations: {
                if isHidden {
                    self.pageControl.alpha = 0.0
                } else {
                    self.pageControl.alpha = 1.0
                }
            },
            completion: { _ in
                self.pageControl.isHidden = isHidden
            }
        )
    }

    public var arrangedViews = [UIView]() {
        willSet {
            removeArrangedViews()
        }

        didSet {
            addArrangedViews()
            syncPageControlToContentView()
            syncSlots()
            setNeedsLayout()
        }
    }

    public var currentPage: Int {
        get {
            return pageControl.currentPage
        }

        set {
            scroll(toPage: newValue)
        }
    }

    public func scroll(toPage page: Int, animated: Bool = true) {
        let destFrame = arrangedViews[page].frame
        let x = destFrame.minX
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
    }

    public func scrollToNextPage(animated: Bool = true) {
        let nextPage = arrangedViews.circularIndex(at: currentPage + 1)
        scroll(toPage: nextPage, animated: animated)
    }

    private var previousSize: CGSize?

    open override func layoutSubviews() {
        let page = currentPage

        super.layoutSubviews()

        updateLayout()

        if let previousSize = previousSize {
            if previousSize != bounds.size {
                scroll(toPage: page, animated: false)
            }
        }
        previousSize = bounds.size

        onDidLayout?(scrollingFromIndex, scrollingToIndex, scrollingFrac)
    }

    open override var clipsToBounds: Bool {
        didSet {
            scrollView.clipsToBounds = clipsToBounds
        }
    }

    open override func setup() {
        super.setup()

        setupScrollView()
        setupPageControl()
    }

    private func removeArrangedViews() {
        for view in arrangedViews {
            view.removeFromSuperview()
        }
        arrangedViewsLeadingConstraints.removeAll()
    }

    private func addArrangedViews() {
        for view in arrangedViews {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
            let leadingConstraint = view.leadingAnchor == contentView.leadingAnchor
            arrangedViewsLeadingConstraints.append(leadingConstraint)
            activateConstraints(
                view.topAnchor == topAnchor,
                view.heightAnchor == heightAnchor,
                view.widthAnchor == widthAnchor,
                leadingConstraint
            )
        }
    }

    private func updateContentSize() {
        contentWidthConstraint.isActive = false
        contentWidthConstraint = contentView.widthAnchor == widthAnchor * CGFloat(slotsCount)
        contentWidthConstraint.isActive = true
    }

    private func setupScrollView() {
        scrollView = ScrollView()
        scrollView.makeTransparent(debugColor: .red, debug: debug)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.constrainToSuperview(identifier: "pagingScroll")

        contentView = PagingContentView()
        contentView.makeTransparent(debugColor: .blue, debug: debug)
        scrollView.addSubview(contentView)
        contentView.constrainToSuperview(identifier: "pagingScrollContent")
        contentWidthConstraint = contentView.widthAnchor == 500
        let contentHeightConstraint = contentView.heightAnchor == heightAnchor - 0.5
        activateConstraints(
            contentWidthConstraint,
            contentHeightConstraint
        )
    }

    private func setupPageControl() {
        pageControl = PageControl()
        pageControl.makeTransparent(debugColor: .red, debug: false)
        pageControl.isUserInteractionEnabled = false
        addSubview(pageControl)
        pageControlBottomConstraint = pageControl.bottomAnchor == bottomAnchor - 20 =&= UILayoutPriorityDefaultLow
        activateConstraints(
            pageControl.centerXAnchor == centerXAnchor,
            pageControl.heightAnchor == 40.0,
            pageControlBottomConstraint
        )
    }

    private func syncSlots() {
        let count = arrangedViews.count
        if isCircular {
            slotsCount = count * 3
        } else {
            slotsCount = count
        }
        updateContentSize()
    }

    private func syncPageControlToContentView() {
        pageControl.numberOfPages = arrangedViews.count
    }

    private func updateArrangedViewConstraints() {
        guard bounds.width > 0 else {
            return
        }

        let xOffset = scrollView.contentOffset.x
        let firstSlotIndex = Int(xOffset / bounds.width)
        for index in 0..<arrangedViews.count {
            let offsetIndex = index - Int(Double(arrangedViews.count) / 2.0 - 0.5)
            let viewIndex = arrangedViews.circularIndex(at: firstSlotIndex + offsetIndex)
            let slotIndex = circularIndex(at: firstSlotIndex + offsetIndex, count: slotsCount)
            let x = CGFloat(slotIndex) * bounds.width
            arrangedViewsLeadingConstraints[viewIndex].constant = x
        }
    }

    private func updateContentOffset() {
        if isCircular {
            let xOffset = scrollView.contentOffset.x
            let width = bounds.width
            let minOffset = width * CGFloat(arrangedViews.count)
            let maxOffset = width * CGFloat(arrangedViews.count * 2)

            var xOffsetNew = xOffset
            if xOffset < minOffset {
                xOffsetNew = xOffset + minOffset
            } else if xOffset >= maxOffset {
                xOffsetNew = xOffset - minOffset
            }
            if xOffsetNew != xOffset {
                scrollView.setContentOffset(CGPoint(x: xOffsetNew, y: 0), animated: false)
                updateLayout()
                //                print("updateContentOffset, xOffset: \(xOffset) xOffsetNew: \(xOffsetNew)")
            }
        }
    }

    private func updateVisibleArrangedViews() {
        var newVisibleViewIndexes = Set<Int>()
        for (index, view) in arrangedViews.enumerated() {
            let r = convert(view.bounds, from: view)
            if r.intersects(bounds) {
                newVisibleViewIndexes.insert(index)
            }
        }
        visibleViewIndexes = newVisibleViewIndexes
    }

    private func updatePageControl() {
        let x = scrollView.contentOffset.x
        let fractionalPosition = x / scrollView.bounds.width
        let page = Int(fractionalPosition + 0.5)
        let circularPage = arrangedViews.circularIndex(at: page)
        pageControl.currentPage = circularPage
    }

    private func updateFractionalPage() {
        let x = scrollView.contentOffset.x
        let fractionalPosition1 = x / scrollView.bounds.width
        let frac = fractionalPosition1.truncatingRemainder(dividingBy: 1.0)
        let index1 = Int(fractionalPosition1.rounded(.down))
        let circularIndex1 = arrangedViews.circularIndex(at: index1)

        let fractionalPosition2 = fractionalPosition1 + 1
        let index2 = Int(fractionalPosition2.rounded(.down))
        let circularIndex2 = arrangedViews.circularIndex(at: index2)

        scrollingFromIndex = circularIndex1
        scrollingToIndex = circularIndex2
        scrollingFrac = Frac(frac)

        if !isCircular {
            if frac < 0.0 {
                scrollingFromIndex = circularIndex2
                scrollingToIndex = circularIndex2
                scrollingFrac = 0.0
            } else if circularIndex2 < circularIndex1 {
                scrollingFromIndex = circularIndex1
                scrollingToIndex = circularIndex1
                scrollingFrac = 0.0
            }
        }
    }

    private func updateLayout() {
        updateArrangedViewConstraints()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        updateContentOffset()
        updateVisibleArrangedViews()
        updatePageControl()
        updateFractionalPage()
    }
}

extension PagingView : UIScrollViewDelegate {
    public func scrollViewDidScroll(_: UIScrollView) {
        setNeedsLayout()
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        onWillBeginDragging?()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        onDidEndDragging?()
    }
}
