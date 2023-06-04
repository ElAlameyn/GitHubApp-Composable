//
//  GitHubClientComposable.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 11.02.2023.
//

import Combine
import ComposableArchitecture
import Foundation
import Moya

extension DependencyValues {
  var gitHubClient: GitHubClient<MoyaService> {
    get { self[GitHubClient<MoyaService>.self] }
    set { self[GitHubClient<MoyaService>.self] = newValue }
  }
}

extension GitHubClient: TestDependencyKey where V == MoyaService {
  static var failValue: GitHubClient<MoyaService> {
    let endpointClosure = { (target: V) -> Endpoint in
      let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
      switch target {
          case .authUserAccount, .authUserRepos, .searchRepo:
            return .withStubResponse(target: target) {
              .networkError(NSError(domain: "Error", code: 408))
            }
        default: return defaultEndpoint
      }
    }

    return GitHubClient<MoyaService>(provider: .init(
      endpointClosure: endpointClosure,
      stubClosure: MoyaProvider.immediatelyStub,
      plugins: [AccessTokenPlugin.tokenPlugin, NetworkLoggerPlugin.verbose]
    )
    )
  }
}

extension GitHubClient: DependencyKey where V == MoyaService {
  static var liveValue: GitHubClient<MoyaService> {
    GitHubClient<MoyaService>()
  }

  static var testValue: GitHubClient<MoyaService> {
    GitHubClient<MoyaService>()
  }
}
