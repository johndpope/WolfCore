//
//  ClearFieldButtonView.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/19/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class ClearFieldButtonView: View {
    public private(set) lazy var button: ClearFieldButton = {
        let button = ClearFieldButton()
        return button
    }()

    public override func setup() {
        super.setup()
        self => [
            button
        ]
        let image = button.image(for: .normal)!
        let size = image.size
        activateConstraints(
            button.centerXAnchor == centerXAnchor,
            button.centerYAnchor == centerYAnchor,

            widthAnchor == size.width,
            heightAnchor == size.height
        )
    }

    public func conceal(animated: Bool) {
        if !isHidden {
            dispatchAnimated(animated, animations: {
                self.button.alpha = 0
            }, completion: { _ in
                self.hide()
            })
        }
    }

    public func reveal(animated: Bool) {
        if isHidden {
            self.show()
            dispatchAnimated(animated) {
                self.button.alpha = 1
            }
        }
    }
}

public class ClearFieldButton: Button {
    public override func setup() {
        super.setup()

        let image = UIImage.init(named: "clearFieldButton", in: Framework.bundle)
        setImage(image, for: .normal)
        setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
    }
}
