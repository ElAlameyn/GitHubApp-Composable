//
//  WebView.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 19.12.2022.
//

import ComposableArchitecture
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  var url: URL
  var webView = WKWebView()
  var type: FunctionalType
  var callBack: (String) -> Void

  enum FunctionalType { case `default`, codeExtract }

  func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
    webView.navigationDelegate = context.coordinator
    return webView
  }

  final class Coordinator: NSObject, WKNavigationDelegate {

    var parent: WebView

    init(parent: WebView) {
      self.parent = parent
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      if parent.type == .codeExtract {
        guard let url = webView.url else { return }
        guard let code = getCodeFrom(url: url) else { return }
        parent.callBack(code)
      }
    }

    private func getCodeFrom(url: URL) -> String? {
      return URLComponents(string: url.absoluteString)
        .flatMap { $0.queryItems }
        .flatMap { items in items.first(where: { $0.name == "code" }) }
        .flatMap { $0.value }
    }
  }

  func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WebView>) {
      webView.load(.init(url: url))
  }

  func makeCoordinator() -> Coordinator {
    let coordinator = Coordinator(parent: self)
    return coordinator
  }
}
