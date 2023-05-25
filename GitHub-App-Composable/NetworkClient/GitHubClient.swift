
//
//  AuthorizationFeatureClient.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 19.12.2022.
//

import Combine
import CombineMoya
import Foundation
import KeychainStored
import Moya

struct GitHubClient<V: TargetType> {
  var provider = MoyaProvider<V>(plugins: [AccessTokenPlugin { _ in
    @KeychainStored(service: "app-auth-token") var token: String?
    return token ?? ""
  }])

  func request<T: Decodable>(_ target: V, of type: T.Type) async -> AnyPublisher<T, Error> {
    provider.requestPublisher(target)
      .receive(on: DispatchQueue.main)
      .map(\.data)
      .decode(type: type, decoder: JSONDecoder.snakeJsonDecoder)
      .mapError { $0 as? MoyaError ?? .underlying($0, nil) }
      .eraseToAnyPublisher()
  }
}


extension JSONDecoder {
  static let snakeJsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
}

extension GitHubClient where V == MoyaService {
  static func getOauthURL(clientId: String) -> URL {
    URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientId)")!
  }
}
