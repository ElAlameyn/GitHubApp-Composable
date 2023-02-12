//
//  WebView.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 19.12.2022.
//

import SwiftUI
import WebKit
import ComposableArchitecture

struct WebView: UIViewRepresentable {
    var url: URL
    var webView = WKWebView()
    var callBack: (String) -> Void

    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var callBack: ((_ accessCode: String) -> Void)?

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            guard let url = webView.url else { return }
            guard let code = getCodeFrom(url: url) else { return }

            print("Acessed code: \(code)")
            callBack?(code)
        }

        private func getCodeFrom(url: URL) -> String? {
            return URLComponents(string: url.absoluteString)
                .flatMap { $0.queryItems }
                .flatMap { items in items.first(where: { $0.name == "code" })}
                .flatMap { $0.value }
        }
    }

    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WebView>)  {
        DispatchQueue.main.async {
            webView.load(.init(url: url))
        }
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.callBack = self.callBack
        return coordinator
    }
}

