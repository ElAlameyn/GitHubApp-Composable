
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

  var requestToken: (MoyaService) async -> AnyPublisher<TokenResponse, MoyaError> = {
    doRequest($0, of: TokenResponse.self)
  }

  var searchRepos: (MoyaService) async -> AnyPublisher<RepositoriesResponse, MoyaError> = {
    doRequest($0, of: RepositoriesResponse.self)
  }


}

extension GitHubClient {
  static var provider: MoyaProvider<MoyaService> = .init(plugins: [
 //   NetworkLoggerPlugin(configuration: .init(logOptions: .successResponseBody))
  ])

  static func doRequest<V: Decodable>(_ target: MoyaService ,of type: V.Type) -> AnyPublisher<V, MoyaError> {
    provider.requestPublisher(target)
      .receive(on: DispatchQueue.main)
//      .map {
//        Logger.log(response: $0)
//        return $0
//      }
      .map(\.data)
      .decode(type: type, decoder: {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
      }()
      )
      .mapError { $0 as? MoyaError ?? .underlying($0, nil) }
      .eraseToAnyPublisher()
  }

  func setMoyaTokenClosure(_ token: String)  {
    let log: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .successResponseBody))
    GitHubClient.provider = MoyaProvider<MoyaService>(plugins: [
      AccessTokenPlugin { _ in token },
      // log
    ])
  }
}

extension GitHubClient {
  static var login = { (clientId: String )in
    URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientId)")!
  }
}
