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
    private var publisher = Publisher<Bulletin>()

    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewController = ContentViewController.instantiate()

        tapAction = contentViewController!.view.addAction(forGestureRecognizer: UITapGestureRecognizer()) { [unowned self] _ in
            self.perform()
        }
        subscribe(to: publisher)
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
        let bulletin1 = MessageBulletin(title: "Banner 1", message: Lorem.shortSentence, backgroundColor: Color.green.lightened(by: 0.8))
        let bulletin2 = MessageBulletin(title: "Banner 2", message: Lorem.sentences(3), backgroundColor: Color.yellow.lightened(by: 0.8))
        let bulletin3 = MessageBulletin(title: "Banner 3", message: Lorem.sentences(2), backgroundColor: Color.red.lightened(by: 0.8), priority: 600)
        let bulletin4 = MessageBulletin(title: "Banner 4", message: Lorem.shortSentence, backgroundColor: Color.purple.lightened(by: 0.8), priority: 400)

        let multiplier: TimeInterval = 1.0

        dispatchOnMain(afterDelay: 0 * multiplier) {
            self.publisher.publish(bulletin1)
        }

        dispatchOnMain(afterDelay: 1 * multiplier) {
            self.publisher.publish(bulletin2)
        }

        dispatchOnMain(afterDelay: 2 * multiplier) {
            self.publisher.publish(bulletin3)
        }

        dispatchOnMain(afterDelay: 3 * multiplier) {
            self.publisher.publish(bulletin4)
        }

        dispatchOnMain(afterDelay: 4 * multiplier) {
            self.publisher.unpublish(bulletin3)
        }

        dispatchOnMain(afterDelay: 5 * multiplier) {
            self.publisher.unpublish(bulletin2)
        }

        dispatchOnMain(afterDelay: 6 * multiplier) {
            self.publisher.unpublish(bulletin1)
        }

        dispatchOnMain(afterDelay: 7 * multiplier) {
            self.publisher.unpublish(bulletin4)
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
