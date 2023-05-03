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
  var gitHubClient: GitHubClient<MoyaService> {
    get { self[GitHubClient<MoyaService>.self] }
    set { self[GitHubClient<MoyaService>.self] = newValue }
  }
}


extension GitHubClient: TestDependencyKey  where V == MoyaService {
  static var failValue: GitHubClient<MoyaService> {
    GitHubClient<MoyaService>()
  }
}

extension GitHubClient: DependencyKey where V == MoyaService {
  static var liveValue: GitHubClient<MoyaService> {
    GitHubClient<MoyaService>()
  }
}

