//
//  PhotoSafeAreaView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/29/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class PhotoSafeAreaView: View {
    public static func addToView(view: UIView) -> PhotoSafeAreaView {
        let safeAreaView = PhotoSafeAreaView()
        view => [
            safeAreaView
        ]
        activateConstraints(
            safeAreaView.centerXAnchor == view.centerXAnchor,
            safeAreaView.centerYAnchor == view.centerYAnchor,
            safeAreaView.widthAnchor == safeAreaView.heightAnchor,
            safeAreaView.widthAnchor == view.widthAnchor =&= UILayoutPriorityDefaultLow,
            safeAreaView.heightAnchor == view.heightAnchor =&= UILayoutPriorityDefaultLow,
            safeAreaView.widthAnchor <= view.widthAnchor,
            safeAreaView.heightAnchor <= view.heightAnchor
        )
        return safeAreaView
    }
}
