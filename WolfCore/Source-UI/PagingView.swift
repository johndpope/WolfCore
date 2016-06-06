//
//  PagingView.swift
//  WolfCore
//
//  Created by Robert McNally on 5/17/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

class PagingContentView: View { }

public class PagingView: View {
    public typealias IndexDispatchBlock = (Int) -> Void

    public var debug = false

    public var arrangedViewAtIndexDidBecomeVisible: IndexDispatchBlock?
    public var arrangedViewAtIndexDidBecomeInvisible: IndexDispatchBlock?
    public var willBeginDragging: DispatchBlock?
    public var didEndDragging: DispatchBlock?
    public private(set) var pageControl: UIPageControl!

    private var scrollView: ScrollView!
    private var contentView: PagingContentView!
    private var contentWidthConstraint: NSLayoutConstraint!
    private var pageControlBottomConstraint: NSLayoutConstraint!
    private var arrangedViewsLeadingConstraints = [NSLayoutConstraint]()
    private var slotsCount: Int = 0

    private var visibleViewIndexes = Set<Int>() {
        willSet {
            let added = newValue.subtract(visibleViewIndexes)
            let removed = visibleViewIndexes.subtract(newValue)
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

    public func setPageControl(hidden hidden: Bool, animated: Bool = true) {
        guard pageControl.hidden != hidden else {
            return
        }

        pageControl.hidden = false

        dispatchAnimated(
            animated,
            animations: {
                if hidden {
                    self.pageControl.alpha = 0.0
                } else {
                    self.pageControl.alpha = 1.0
                }
            },
            completion: { _ in
                self.pageControl.hidden = hidden
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
        let nextPage = arrangedViews.circularIndex(currentPage + 1)
        scroll(toPage: nextPage, animated: animated)
    }

    private var previousSize: CGSize?

    public override func layoutSubviews() {
        let page = currentPage

        super.layoutSubviews()

        updateLayout()

        if let previousSize = previousSize {
            if previousSize != bounds.size {
                scroll(toPage: page, animated: false)
            }
        }
        previousSize = bounds.size
    }

    public override var clipsToBounds: Bool {
        didSet {
            scrollView.clipsToBounds = clipsToBounds
        }
    }

    public override func setup() {
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
        contentWidthConstraint.active = false
        contentWidthConstraint = contentView.widthAnchor == widthAnchor * CGFloat(slotsCount)
        contentWidthConstraint.active = true
    }

    private func setupScrollView() {
        scrollView = ScrollView()
        scrollView.makeTransparent(debugColor: .Red, debug: debug)
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.constrainToSuperview(identifier: "pagingScroll")

        contentView = PagingContentView()
        contentView.makeTransparent(debugColor: .Blue, debug: debug)
        scrollView.addSubview(contentView)
        contentView.constrainToSuperview(identifier: "pagingScrollContent")
        contentWidthConstraint = contentView.widthAnchor == 500
        let contentHeightConstraint = contentView.heightAnchor == scrollView.heightAnchor - 0.5
        activateConstraints(
            contentWidthConstraint,
            contentHeightConstraint
        )
    }

    private func setupPageControl() {
        pageControl = ~UIPageControl()
        pageControl.makeTransparent(debugColor: .Red, debug: false)
        pageControl.userInteractionEnabled = false
        addSubview(pageControl)
        pageControlBottomConstraint = pageControl.bottomAnchor == bottomAnchor - 20 =&= UILayoutPriorityDefaultLow
        activateConstraints(
            pageControl.centerXAnchor == centerXAnchor,
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
            let viewIndex = arrangedViews.circularIndex(firstSlotIndex + offsetIndex)
            let slotIndex = circularIndex(firstSlotIndex + offsetIndex, count: slotsCount)
            let x = CGFloat(slotIndex) * bounds.width
            arrangedViewsLeadingConstraints[viewIndex].constant = x
        }
    }

    private func updateContentOffset() {
        if isCircular {
            let xOffset = scrollView.contentOffset.x
            let width = bounds.width
            let minOffset = width * 4
            let maxOffset = width * 8

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
        for (index, view) in arrangedViews.enumerate() {
            let r = convertRect(view.bounds, fromView: view)
            if r.intersects(bounds) {
                newVisibleViewIndexes.insert(index)
            }
        }
        visibleViewIndexes = newVisibleViewIndexes
    }

    private func updatePageControl() {
        let x = scrollView.contentOffset.x
        let page = Int(x / scrollView.bounds.width + 0.5)
        let circularPage = arrangedViews.circularIndex(page)
        pageControl.currentPage = circularPage
    }

    private func updateLayout() {
        updateArrangedViewConstraints()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        updateContentOffset()
        updateVisibleArrangedViews()
        updatePageControl()
    }
}

extension PagingView : UIScrollViewDelegate {
    public func scrollViewDidScroll(_: UIScrollView) {
        setNeedsLayout()
    }

    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        willBeginDragging?()
    }

    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDragging?()
    }
}
