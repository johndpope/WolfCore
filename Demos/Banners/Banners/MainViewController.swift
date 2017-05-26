//
//  MainViewController.swift
//  Banners
//
//  Created by Wolf McNally on 5/22/17.
//  Copyright © 2017 Arciem LLC. All rights reserved.
//

import UIKit
import WolfCore

class MainViewController: BannerViewController {
    var tapAction: GestureRecognizerAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewController = ContentViewController.instantiate()

        tapAction = contentViewController!.view.addAction(forGestureRecognizer: UITapGestureRecognizer()) { [unowned self] _ in
            self.perform()
        }
    }

    override func updateAppearance(skin: Skin?) {
        super.updateAppearance(skin: skin)
        view.normalBackgroundColor = .blue
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        perform()
    }

    private func perform() {
        var flyer1: MessageFlyer!
        var flyer2: MessageFlyer!
        var flyer3: MessageFlyer!
        var flyer4: MessageFlyer!

        let multiplier: TimeInterval = 1.0

        dispatchOnMain(afterDelay: 0 * multiplier) {
            flyer1 = MessageFlyer(title: "Banner 1", message: Lorem.shortSentence, backgroundColor: UIColor.green.lightened(by: 0.8))
            self.addView(MessageFlyerView(flyer: flyer1), for: flyer1)
        }

        dispatchOnMain(afterDelay: 1 * multiplier) {
            flyer2 = MessageFlyer(title: "Banner 2", message: Lorem.sentences(3), backgroundColor: UIColor.yellow.lightened(by: 0.8))
            self.addView(MessageFlyerView(flyer: flyer2), for: flyer2)
        }

        dispatchOnMain(afterDelay: 2 * multiplier) {
            flyer3 = MessageFlyer(title: "Banner 3", message: Lorem.sentences(2), backgroundColor: UIColor.red.lightened(by: 0.8), priority: 600)
            self.addView(MessageFlyerView(flyer: flyer3), for: flyer3)
        }

        dispatchOnMain(afterDelay: 3 * multiplier) {
            flyer4 = MessageFlyer(title: "Banner 4", message: Lorem.shortSentence, backgroundColor: UIColor.purple.lightened(by: 0.8), priority: 400)
            self.addView(MessageFlyerView(flyer: flyer4), for: flyer4)
        }

        dispatchOnMain(afterDelay: 4 * multiplier) {
            self.removeView(for: flyer3)
        }

        dispatchOnMain(afterDelay: 5 * multiplier) {
            self.removeView(for: flyer2)
        }

        dispatchOnMain(afterDelay: 6 * multiplier) {
            self.removeView(for: flyer1)
        }

        dispatchOnMain(afterDelay: 7 * multiplier) {
            self.removeView(for: flyer4)
        }
    }
}

class ContentViewController: ViewController {
    static func instantiate() -> ContentViewController {
        return ContentViewController()
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    private lazy var placeholderView: PlaceholderView = {
        let view = PlaceholderView(title: "Tap for More Banners")
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view => [
            placeholderView
        ]
        placeholderView.constrainFrame()
    }
}
