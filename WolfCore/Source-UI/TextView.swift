//
//  TextView.swift
//  WolfCore
//
//  Created by Robert McNally on 5/27/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public typealias TagAction = (String) -> Void

public class TextView: UITextView {
    private var tagTapActions = [String: TagAction]()
    private var tapAction: GestureRecognizerAction!

    public var followsTintColor = false {
        didSet {
            syncToTintColor()
        }
    }

    public convenience init() {
        self.init(frame: .zero, textContainer: nil)
    }

    public convenience init(textContainer: NSTextContainer) {
        self.init(frame: .zero, textContainer: textContainer)
    }

    public override init(frame: CGRect, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    private func _setup() {
        ~~self
        setup()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearance()
    }

    /// Override in subclasses
    public func setup() {
    }

    /// Override in subclasses
    public func updateAppearance() {
        syncToTintColor()
    }
}

extension TextView {
    func syncToTintColor() {
        if followsTintColor {
            textColor = tintColor ?? .Black
        }
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        syncToTintColor()
    }
}

extension TextView {
    public func setTapAction(forTag tag: String, action: TagAction) {
        tagTapActions[tag] = action
        syncToTagTapActions()
    }

    public func removeTapAction(forTag tag: String) {
        tagTapActions[tag] = nil
        syncToTagTapActions()
    }

    private func syncToTagTapActions() {
        if tagTapActions.count == 0 {
            tapAction = nil
        } else {
            if tapAction == nil {
                tapAction = addAction(forGestureRecognizer: UITapGestureRecognizer()) { [unowned self] recognizer in
                    self.handleTap(fromRecognizer: recognizer)
                }
            }
        }
    }

    private func handleTap(fromRecognizer recognizer: UIGestureRecognizer) {
        var location = recognizer.locationInView(self)
        location.x -= textContainerInset.left
        location.y -= textContainerInset.top
        let charIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if charIndex < textStorage.length {
            let attributedText = self.attributedText§
            for (tag, action) in tagTapActions {
                let index = attributedText.string.index(fromLocation: charIndex)
                if let tappedText = attributedText.getString(forTag: tag, atIndex: index) {
                    action(tappedText)
                }
            }
        }
    }
}
