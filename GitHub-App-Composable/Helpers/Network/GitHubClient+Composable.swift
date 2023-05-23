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

extension Endpoint {
  static func withStubResponse<V: TargetType>(target: V, _ stubResponse: SampleResponseClosure) -> Endpoint {
    return Endpoint(
      url: URL(target: target).absoluteString,
      sampleResponseClosure: {
        .networkError(NSError(domain: "This is my own custom error", code: 408))
      },
      method: target.method,
      task: target.task,
      httpHeaderFields: target.headers
    )
  }
}

extension GitHubClient: TestDependencyKey where V == MoyaService {
  static var failValue: GitHubClient<MoyaService> {
    let endpointClosure = { (target: V) -> Endpoint in
      let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
      switch target {
        case .searchRepo:
          return .withStubResponse(target: target) {
            .networkError(NSError(domain: "This is my own custom error", code: 408))
          }
        default: return defaultEndpoint
      }
    }

    return GitHubClient<MoyaService>(
      provider: .init(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub, plugins: [AccessTokenPlugin.tokenPlugin])
    )
  }
}

extension GitHubClient: DependencyKey where V == MoyaService {
  static var liveValue: GitHubClient<MoyaService> {
    GitHubClient<MoyaService>()
  }
}
