
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


struct GitHubClient {

  var requestToken: (MoyaService) async throws -> AnyPublisher<TokenResponse, MoyaError> = {
    publisher($0, of: TokenResponse.self)
  }

}

extension GitHubClient {
  static let provider = MoyaProvider<MoyaService>()

  static func publisher<V: Decodable>(_ target: MoyaService ,of type: V.Type) -> AnyPublisher<V, MoyaError> {
    provider.requestPublisher(target)
      .receive(on: DispatchQueue.main)
      .map(\.data)
      .decode(type: type, decoder: JSONDecoder())
      .mapError { $0 as? MoyaError ?? .underlying($0, nil) }
      .eraseToAnyPublisher()
  }
}

private var cancellable = Set<AnyCancellable>()

extension Publisher where Output: Decodable, Failure == MoyaError {
  func asyncExtract() async throws -> Output {
    return try await withCheckedThrowingContinuation { next in
      self.sink(receiveCompletion: {
        switch $0 {
          case .finished:
            Swift.print("[API SUCCESSFUL] - \(Output.self) achieved")
          case .failure(let error):
            Swift.print("[API FAIL] - \(Output.self) not achieved: \(error.localizedDescription)")
            if case let .statusCode(response) = error {
              Swift.print("Invalid status code \(response.statusCode)")
            }
            next.resume(throwing: error)
        }
      }, receiveValue: {
        next.resume(returning: $0)
      }
      )
//        .sink(logInfo: "Publisher with \(Output.self)") {
//          next.resume(returning: $0)
//        } receiveError: {
//          next.resume(throwing: $0)
//        }
        .store(in: &cancellable)
    }
  }
}


extension GitHubClient {
  static var login = { (clientId: String )in
    URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientId)")!
  }
}
