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

    var reachability: Reachability!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let endpoint = Endpoint(name: "Google", host: "google.com", basePath: "")
        reachability = Reachability(endpoint: endpoint)
        subscribe(to: reachability.publisher)
        reachability.start()

        perform()
    }

    private class MyMessageBulletin: MessageBulletin {
        private let backgroundColor: UIColor

        init(title: String, message: String, priority: Int = normalPriority, duration: TimeInterval? = nil, backgroundColor: UIColor) {
            self.backgroundColor = backgroundColor
            super.init(title: title, message: message, priority: priority, duration: nil)
        }

        override func newBulletinView() -> BulletinView {
            let bulletinView = super.newBulletinView()
            let skin = MessageSkin(backgroundColor: backgroundColor)
            bulletinView.view.skin = skin
            return bulletinView
        }
    }

    public class MessageSkin: DefaultSkin {
        private let _bulletinBackgroundColor: UIColor
        public override var bulletinBackgroundColor: UIColor {
            return _bulletinBackgroundColor
        }

        public init(backgroundColor: UIColor) {
            _bulletinBackgroundColor = backgroundColor
            super.init()
        }
    }

    private func perform() {
        let bulletin1 = MyMessageBulletin(title: "Banner 1", message: Lorem.shortSentence, backgroundColor: UIColor.green.lightened(by: 0.8))
        let bulletin2 = MyMessageBulletin(title: "Banner 2", message: Lorem.sentences(3), backgroundColor: UIColor.yellow.lightened(by: 0.8))
        let bulletin3 = MyMessageBulletin(title: "Banner 3", message: Lorem.sentences(2), priority: 600, backgroundColor: UIColor.red.lightened(by: 0.8))
        let bulletin4 = MyMessageBulletin(title: "Banner 4", message: Lorem.shortSentence, priority: 400, backgroundColor: UIColor.purple.lightened(by: 0.8))

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
