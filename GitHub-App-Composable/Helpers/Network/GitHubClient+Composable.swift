//
//  GitHubClientComposable.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 11.02.2023.
//

import ComposableArchitecture
import Foundation
import Combine
import Moya

extension DependencyValues {
  var gitHubClient: GitHubClient {
    get { self[GitHubClient.self] }
    set { self[GitHubClient.self] = newValue }
  }
}


extension GitHubClient: TestDependencyKey {
  static var failValue: GitHubClient = .init(searchRequest: .init(
    .live, tokenService: "app-auth-token", { _ in
      Fail(error: .statusCode(
        .init(
          statusCode: 200,
          data: .init()
        )
      ))
      .eraseToAnyPublisher()
    }
  ))

  static var successValue: GitHubClient = .init(tokenRequest: .init(
    .live, tokenService: "app-auth-token", { _ in
      Just(.mock)
        .setFailureType(to: MoyaError.self)
      .eraseToAnyPublisher()    }
  ))
}

extension GitHubClient: DependencyKey {
  static var liveValue: GitHubClient = .init()
}

