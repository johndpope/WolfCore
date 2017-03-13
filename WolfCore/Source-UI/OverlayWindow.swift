//
//  OverlayWindow.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/9/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public var overlayWindow = OverlayWindow()
public var overlayViewController = OverlayViewController()
public var overlayView: View {
    return overlayWindow.subviews[0] as! View
}

public class OverlayWindow: UIWindow {
    public init() {
        super.init(frame: .zero)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    private func _setup() {
        __setup()
        frame = UIScreen.main.bounds
        rootViewController = overlayViewController
        windowLevel = UIWindowLevelAlert + 1
        show()
        setup()
    }

    open func setup() { }

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isTransparentToTouch(at: point, with: event)
    }
}

public class OverlayViewController: ViewController {
    public override func loadView() {
        let v = View()
        v.transparentToTouches = true
        v.translatesAutoresizingMaskIntoConstraints = true
        view = v
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.makeTransparent()
    }
}
