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

// struct Error: Swift.Error, Equatable { }

extension NSError {
  static let `default` = NSError(domain: "Error", code: 408)
}

extension GitHubClient: DependencyKey where V == MoyaService {
  static var testValue: GitHubClient<MoyaService> {
    let endpointClosure = { (target: V) -> Endpoint in
      let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
      switch target {
        case  .searchRepo:
          return .withStubResponse(target: target) {
            let repos = RepositoriesResponse(totalCount: nil, incompleteResults: nil, items: [])
            let data = try! JSONEncoder().encode(repos)
            return .networkResponse(200, data)
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

extension GitHubClient: TestDependencyKey where V == MoyaService {
  static var failValue: GitHubClient<MoyaService> {
    let endpointClosure = { (target: V) -> Endpoint in
      let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
      switch target {
        case .authUserAccount, .authUserRepos, .searchRepo:
          return .withStubResponse(target: target) {
            .networkError(.default)
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

extension GitHubClient {
  static var liveValue: GitHubClient<MoyaService> {
    GitHubClient<MoyaService>()
  }
}
