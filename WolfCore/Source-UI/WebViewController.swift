//
//  WebViewController.swift
//  WolfCore
//
//  Created by Robert McNally on 8/10/15.
//  Copyright © 2016 Vixlet. All rights reserved.
//

import UIKit
import WebKit

open class WebViewController: ViewController {
    var url: URL!

    public static var appearance: Appearance = {
        return Appearance()
    }()

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backItem: UIBarButtonItem!
    @IBOutlet weak var forwardItem: UIBarButtonItem!
    @IBOutlet weak var reloadItem: UIBarButtonItem!

    public class Appearance {
        public init() { }
        public let barTintColor = SkinColor(withDefault: .yellow)
        public let tintColor = SkinColor(withDefault: .red)
    }

    public static func present(from presentingViewController: UIViewController, url: URL) {
        let navController: NavigationController = loadInitialViewController(fromStoryboardNamed: "WebViewController", in: Framework.bundle)
        let webController = navController.viewControllers[0] as! WebViewController
        webController.url = url
        presentingViewController.present(navController, animated: true, completion: nil)
    }

    open override func updateAppearance() {
        super.updateAppearance()
        if let navigationController = navigationController {
            let appearance = type(of: self).appearance
            let navigationBar = navigationController.navigationBar
            navigationBar.barTintColor = appearance.barTintColor®
            navigationBar.tintColor = appearance.tintColor®

            let toolbar = navigationController.toolbar!
            toolbar.barTintColor = appearance.barTintColor®
            toolbar.tintColor = appearance.tintColor®
        }
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        logTrace(navigationController)
        navigationController?.isToolbarHidden = false
        var titleTextAttributes = navigationController!.navigationBar.titleTextAttributes ?? [String: AnyObject]()
        titleTextAttributes[NSFontAttributeName] = UIFont.boldSystemFont(ofSize: 12)
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes

        webView.loadRequest(URLRequest(url: url))

        syncToWebView()
    }

    @IBAction func backAction() {
        webView.goBack()
    }

    @IBAction func forwardAction() {
        webView.goForward()
    }

    @IBAction func reloadAction() {
        webView.reload()
    }

    @IBAction func doneAction() {
        dismiss(animated: true, completion: nil)
    }

    func syncToWebView() {
        backItem.isEnabled = webView.canGoBack
        forwardItem.isEnabled = webView.canGoForward
        reloadItem.isEnabled = !webView.isLoading
    }
}

extension WebViewController: UIWebViewDelegate {
    public func webViewDidStartLoad(webView: UIWebView) {
        syncToWebView()
    }

    public func webViewDidFinishLoad(webView: UIWebView) {
        syncToWebView()
        title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }

    public func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        syncToWebView()
    }
}
