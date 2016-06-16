//
//  Label.swift
//  WolfCore
//
//  Created by Robert McNally on 7/22/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public class Label: UILabel {
    private var tagTapActions = [String: TagAction]()
    private var tapAction: GestureRecognizerAction!

    /// Can be set in Interface Builder
    public var scalesFontSize: Bool = false

    /// Can be set in Interface Builder
    public var transparentToTouches: Bool = false

    /// Can be set in Interface Builder
    public var followsTintColor: Bool = false {
        didSet {
            syncToTintColor()
        }
    }

    private var baseFont: UIFontDescriptor!

    public func resetBaseFont() {
        guard scalesFontSize else { return }

        baseFont = font.fontDescriptor()
    }

    public func syncFontSize(toFactor factor: CGFloat) {
        guard scalesFontSize else { return }

        let pointSize = baseFont.pointSize * factor
        font = UIFont(descriptor: baseFont, size: pointSize)
    }

    public override var text: String? {
        didSet {
            syncToTintColor()
        }
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        syncToTintColor()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized(onlyIfTagged: true)
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
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

    // Override in subclasses
    public func setup() { }

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if transparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }
}

extension Label {
    func syncToTintColor() {
        let tintColor = self.tintColor ?? .black
        if followsTintColor {
            if let attributedText = attributedText {
                let attributedText = attributedText§
                attributedText.enumerateAttribute(overrideTintColorTag) { (value, _, substring) -> Bool in
                    if value == nil {
                        substring.foregroundColor = tintColor
                    }
                    return false
                }
                self.attributedText = attributedText
            } else {
                textColor = tintColor
            }
        }
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        syncToTintColor()
    }
}

extension Label {
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
                isUserInteractionEnabled = true

                tapAction = addAction(forGestureRecognizer: UITapGestureRecognizer()) { [unowned self] recognizer in
                    self.handleTap(fromRecognizer: recognizer)
                }
            }
        }
    }

    private func handleTap(fromRecognizer recognizer: UIGestureRecognizer) {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer()
        let textStorage = NSTextStorage(attributedString: attributedText!)
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.size = bounds.size

        let locationOfTouchInLabel = recognizer.location(in: self)
        let labelSize = bounds.size
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = (labelSize - textBoundingBox.size) * 0.5 - textBoundingBox.minXminY
        let locationOfTouchInTextContainer = CGPoint(vector: locationOfTouchInLabel - textContainerOffset)
        let charIndex = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if charIndex < textStorage.length {
            let attributedText = (self.attributedText!)§
            for (tag, action) in tagTapActions {
                let index = attributedText.string.index(fromLocation: charIndex)
                if let tappedText = attributedText.getString(forTag: tag, atIndex: index) {
                    action(tappedText)
                }
            }
        }
    }
}
