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
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewController = ContentViewController.instantiate()
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

        var banner1: Banner!
        var banner2: Banner!
        var banner3: Banner!
        var banner4: Banner!

        dispatchOnMain(afterDelay: 1.0) {
            let bannerView = BannerView(title: "Banner 1", message: Lorem.shortSentence, backgroundColor: UIColor.green.lightened(by: 0.8))
            banner1 = self.addBanner(view: bannerView)
        }

        dispatchOnMain(afterDelay: 2.0) {
            let bannerView = BannerView(title: "Banner 2", message: Lorem.sentences(3), backgroundColor: UIColor.yellow.lightened(by: 0.8))
            banner2 = self.addBanner(view: bannerView)
        }

        dispatchOnMain(afterDelay: 3.0) {
            let bannerView = BannerView(title: "Banner 3", message: Lorem.sentences(2), backgroundColor: UIColor.red.lightened(by: 0.8))
            banner3 = self.addBanner(view: bannerView, priority: 600)
        }

        dispatchOnMain(afterDelay: 4.0) {
            let bannerView = BannerView(title: "Banner 4", message: Lorem.shortSentence, backgroundColor: UIColor.purple.lightened(by: 0.8))
            banner4 = self.addBanner(view: bannerView, priority: 400)
        }

        dispatchOnMain(afterDelay: 5.0) { 
            self.removeBanner(banner3)
        }

        dispatchOnMain(afterDelay: 6.0) {
            self.removeBanner(banner2)
        }

        dispatchOnMain(afterDelay: 7.0) {
            self.removeBanner(banner1)
        }

        dispatchOnMain(afterDelay: 8.0) {
            self.removeBanner(banner4)
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
        let view = PlaceholderView(title: "Content")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view => [
            placeholderView
        ]
        placeholderView.constrainFrame()
    }
    
    //override func viewWillAppear(_ animated: Bool) {
    //    super.viewWillAppear(animated)
    //    view.normalBackgroundColor = .red
    //}
}
