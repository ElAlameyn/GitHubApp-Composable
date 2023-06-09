//
//  OauthViewConroller.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 09.06.2023.
//

import OAuthSwift
import UIKit
import WebKit

final class OauthViewContoller: OAuthWebViewController {
  var targetURL: URL?
  let webView = WKWebView()
  let controller = OAuthWebViewController()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.webView.frame = self.view.bounds
    self.webView.navigationDelegate = self
    self.webView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.webView)
    self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: ["view": self.webView]))
    self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": self.webView]))
    self.loadAddressURL()
  }

  override func handle(_ url: URL) {
    self.targetURL = url
    super.handle(url)
    self.loadAddressURL()
  }

  func loadAddressURL() {
    guard let url = targetURL else {
      return
    }
    let req = URLRequest(url: url)
    DispatchQueue.main.async {
      self.webView.load(req)
    }
  }
}

extension OauthViewContoller: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if let url = navigationAction.request.url, url.scheme == "oauth-swift" {
      OAuthSwift.handle(url: url)
      decisionHandler(.cancel)
      self.dismissWebViewController()
      return
    }
    return decisionHandler(.allow)
  }

  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    print("\(error)")
    self.dismissWebViewController()
  }
}
