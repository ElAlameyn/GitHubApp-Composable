//
//  GitHubClientComposable.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 11.02.2023.
//

import ComposableArchitecture
import Foundation

extension DependencyValues {
  var gitHubClient: GitHubClient {
    get { self[GitHubClient.self] }
    set { self[GitHubClient.self] = newValue }
  }
}

extension GitHubClient: TestDependencyKey {
  static var failValue: GitHubClient = .init { _ in
      .failure(NSError(domain: "Failed", code: 200))
  }

  static var successValue: GitHubClient = .init { _ in
      .success(.init(.mock))
  }
}

extension GitHubClient: DependencyKey {
  static var liveValue: GitHubClient = .init()
}

