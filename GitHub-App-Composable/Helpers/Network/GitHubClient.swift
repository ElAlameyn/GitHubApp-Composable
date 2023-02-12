
//
//  AuthorizationFeatureClient.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 19.12.2022.
//

import Foundation
import Moya


struct GitHubClient {
  var requestToken: (MoyaService) async -> Result<TokenResponse?, Error> = {
    await doRequest(kind: $0, of: TokenResponse.self)
  }
}

extension GitHubClient {
  static let provider = MoyaProvider<MoyaService>()
}

private func doRequest<V: Decodable>(kind: MoyaService, of type: V.Type) async -> Result<V?, Error> {
  return await withCheckedContinuation { next in
    GitHubClient.provider.request(kind) { result in
      switch result {
        case let .success(response):
          Logger.log(response: response)
          let resultValue = try? JSONDecoder().decode(type, from: response.data)
          next.resume(returning: .success(resultValue))
        case let .failure(error):
          next.resume(returning: .failure(error))
      }
    }
  }
}


extension GitHubClient {
  static var login = { (clientId: String )in
    URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientId)")!
  }
}
