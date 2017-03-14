//
//  TextView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/27/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

open class TextView: UITextView, Skinnable {
    var tagTapActions = [String: TagAction]()
    var tapAction: GestureRecognizerAction!

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
        __setup()
        setup()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        _didMoveToSuperview()
    }

    open func updateAppearance(skin: Skin?) {
        _updateAppearance(skin: skin)
        syncToFontStyle(for: skin)
    }

    open func setup() {
    }

    @IBInspectable public var fontStyle: String? = nil
    public var fontStyleName: FontStyleName? {
        didSet {
            syncToFontStyle()
        }
    }

    open override var text: String! {
        didSet {
            syncToFontStyle()
        }
    }
}

extension TextView {
    func syncToFontStyle(for skin: Skin?) {
        textColor = skin?.textColor
        guard let skin = skin else { return }
        let fontStyle = self.fontStyle ?? fontStyleName?.rawValue
        if let style = skin.fontStyleNamed(fontStyle) {
            font = style.font
            textColor = style.color
            attributedText = style.apply(to: text)
        }
    }

    func syncToFontStyle() {
        syncToFontStyle(for: skin)
    }
}

extension TextView {
    func syncToTintColor() {
        if followsTintColor {
            textColor = tintColor ?? .black
        }
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        syncToTintColor()
    }
}

extension TextView {
    public func setTapAction(forTag tag: String, action: @escaping TagAction) {
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
        var location = recognizer.location(in: self)
        location.x -= textContainerInset.left
        location.y -= textContainerInset.top
        let charIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if charIndex < textStorage.length {
            let attributedText = (self.attributedText§)!
            for (tag, action) in tagTapActions {
                let index = attributedText.string.index(fromLocation: charIndex)
                if let tappedText = attributedText.getString(forTag: tag, atIndex: index) {
                    action(tappedText)
                }
            }
        }
    }
}

extension TextView {
    public func characterPosition(for point: CGPoint) -> UITextPosition {
        guard !text.isEmpty else { return beginningOfDocument }

        let attrText = (attributedText!)§
        let font = attrText.font

        let r1: CGRect
        let lastChar = text.substring(from: text.index(text.endIndex, offsetBy: -1))
        if lastChar == "\n" {
            let r = caretRect(for: position(from: endOfDocument, offset: -1)!)
            let sr = caretRect(for: position(from: beginningOfDocument, offset: 0)!)
            r1 = CGRect(origin: CGPoint(x: sr.minX, y: r.minY + font.lineHeight), size: r.size)
        } else {
            r1 = caretRect(for: position(from: endOfDocument, offset: 0)!)
        }

        print("point: \(point), endRect: \(r1)")

        if point.x > r1.minX && point.y > r1.minY {
            return endOfDocument
        }

        if point.y >= r1.maxY {
            return endOfDocument
        }

        let index = textStorage.layoutManagers[0].characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return position(from: beginningOfDocument, offset: index)!
    }
}
