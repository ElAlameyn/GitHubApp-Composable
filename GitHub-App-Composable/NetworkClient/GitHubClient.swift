
//
//  AuthorizationFeatureClient.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 19.12.2022.
//

import Combine
import CombineMoya
import ComposableArchitecture
import Foundation
import KeychainStored
import Moya
import OAuthSwift

struct GitHubClient<V: TargetType> {
  var provider = MoyaProvider<V>(plugins: [
    AccessTokenPlugin { _ in
      @KeychainStored(service: "app-auth-token") var token: String?
      return token ?? ""
    },
    NetworkLoggerPlugin.verbose
  ])

  func request<T: Decodable>(_ target: V, of type: T.Type) async -> AnyPublisher<T, Error> {
    provider.requestPublisher(target)
      .receive(on: DispatchQueue.main)
      .map(\.data)
      .decode(type: type, decoder: JSONDecoder.snakeJsonDecoder)
      .mapError { $0 as? MoyaError ?? $0 }
      .eraseToAnyPublisher()
  }

  func authorize(oauth: OAuth2Swift) async throws -> TokenResponse {
    try await withCheckedThrowingContinuation { continuation in
      let stateOauth = generateState(withLength: 20)
      oauth.authorize(
        withCallbackURL: URL(string: "oauth-swift://oauth-callback/github")!,
        scope: "user,repo",
        state: stateOauth,
        headers: ["Accept": "application/vnd.github+json"],
        completionHandler: { result in
          switch result {
            case let .success((_, response, _)):
              do {
                let result = try JSONDecoder.snakeJsonDecoder.decode(TokenResponse.self, from: response!.data)
                continuation.resume(returning: result)
              } catch {
                continuation.resume(throwing: error)
              }
            case let .failure(error):
              print(error)
              continuation.resume(throwing: error)
          }
        }
      )
    }
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
