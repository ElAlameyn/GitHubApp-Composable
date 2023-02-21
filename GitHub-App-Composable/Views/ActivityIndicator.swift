//
//  ActivityIndicator.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 20.02.2023.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

  @Binding var isAnimating: Bool
  let style: UIActivityIndicatorView.Style

  func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
    let view = UIActivityIndicatorView(style: style)
    view.color = .white
    return view
  }

  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
    isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
  }
}
