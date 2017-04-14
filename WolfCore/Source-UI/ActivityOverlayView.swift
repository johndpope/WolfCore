//
//  ActivityOverlayView.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/12/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class ActivityOverlayView: View {
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = ~UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        view.hidesWhenStopped = false
        return view
    }()

    public override var isHidden: Bool {
        didSet {
            if isHidden {
                activityIndicatorView.stopAnimating()
            } else {
                activityIndicatorView.startAnimating()
            }
        }
    }

    private lazy var frameView: View = {
        let view = View()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.constrainSize(to: CGSize(width: 80, height: 80))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()

    override public func setup() {
        super.setup()
        backgroundColor = UIColor(white: 0, alpha: 0.5)

        self => [
            frameView => [
                activityIndicatorView
            ]
        ]

        activityIndicatorView.constrainCenterToCenter()
        frameView.constrainCenterToCenter()
        hide()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            constrainFrame()
        }
    }
}

//class LoadingViewController: ViewController {
//    private lazy var mainView: LoadingOverlayView = {
//        let view = LoadingOverlayView()
//        return view
//    }()
//
//    override func loadView() {
//        self.view = mainView
//    }
//}
