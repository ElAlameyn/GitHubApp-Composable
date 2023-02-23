
//
//  AuthorizationFeatureClient.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 19.12.2022.
//

import Foundation
import Moya
import CombineMoya
import Combine
import KeychainStored


struct GitHubClient {
  var tokenRequest = Provider<TokenResponse, MoyaService>(.live, tokenService: "")
  var searchRequest = Provider<RepositoriesResponse, MoyaService>(.live)
}

extension GitHubClient {
  static var login = { (clientId: String )in
    URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientId)")!
  }
}

enum MoyaStub<V: TargetType> {
  case live, test
  case custom(closure: () -> MoyaProvider<V>)
}

struct Provider<T: Decodable, V: TargetType> {
  var provider: MoyaProvider<V>
  var run: (V) async -> AnyPublisher<T, MoyaError>
}

extension Provider {
  init(_ type: MoyaStub<V>,
       tokenService: String = "app-auth-token",
       _ f: ((V) -> AnyPublisher<T, MoyaError>)? = nil) {
    @KeychainStored(service: tokenService) var token: String?

    switch type {
      case .live:
        if let token = token {
          provider = MoyaProvider<V>(plugins: [
            AccessTokenPlugin { _ in token },
            NetworkLoggerPlugin(configuration: .init(logOptions: .successResponseBody))
          ])
        } else  {
          provider = MoyaProvider<V>(plugins: [
            NetworkLoggerPlugin(configuration: .init(logOptions: .successResponseBody))
          ])
        }
      case .test:
       provider = MoyaProvider<V>(stubClosure: MoyaProvider.immediatelyStub)
      case .custom(closure: let f): provider = f()
    }
    if let f = f {
      run = f
    } else {
      run = { [unowned provider] (target: V) in
        provider.requestPublisher(target)
          .receive(on: DispatchQueue.main)
          .map(\.data)
          .decode(type: T.self, decoder: {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
          }()
          )
          .mapError { $0 as? MoyaError ?? .underlying($0, nil) }
          .eraseToAnyPublisher()
      }
    }
  }
}

