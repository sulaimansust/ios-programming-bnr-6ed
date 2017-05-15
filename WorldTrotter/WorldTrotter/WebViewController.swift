//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Laurent Boileau on 2017-05-15.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!

    override func loadView() {
        let webViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.bignerdranch.com")
        if let theUrl = url {
            let request = URLRequest(url: theUrl)
            webView.load(request)
        }
    }

}
