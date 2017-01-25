//
//  StackView.swift
//  WolfCore
//
//  Created by Robert McNally on 5/26/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSStackView = UIStackView
#elseif os(macOS)
    import Cocoa
    public typealias OSStackView = NSStackView
#endif

open class StackView: OSStackView, Skinnable {
    private var _mySkin: Skin?
    public var mySkin: Skin? {
        get { return _mySkin ?? inheritedSkin }
        set { _mySkin = newValue; updateAppearanceContainer(skin: _mySkin) }
    }

    public var transparentToTouches = false

    public convenience init() {
        self.init(frame: .zero)
    }

    public convenience init(arrangedSubviews views: [OSView]) {
        self.init(arrangedSubviews: views)
        _setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    #if os(macOS)
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            _setup()
        }
    #else
        public required init(coder: NSCoder) {
            super.init(coder: coder)
            _setup()
        }
    #endif

    private func _setup() {
        ~self
        setup()
    }

    #if !os(macOS)
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearanceContainer(skin: mySkin)
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if transparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }
    #endif

    open func updateAppearance(skin: Skin?) {
        _updateAppearance(skin: skin)
    }

    open func setup() { }
}
