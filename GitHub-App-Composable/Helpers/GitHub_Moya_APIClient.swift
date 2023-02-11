
//
//  ApiClient.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 19.12.2022.
//

import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay
import Moya
import CombineMoya
import Combine

extension DependencyValues {
  var apiClient: ApiClient {
    get { self[ApiClient.self] }
    set { self[ApiClient.self] = newValue }
  }
}

struct ApiClient  {
  var requestToken: (TargetType, TokenResponse.Type) async -> TokenResponse? = { await doRequest(kind: $0, of: $1) }
}

private func doRequest<T: TargetType, V: Decodable>(kind: T, of type: V.Type) async -> V? {
  return await withCheckedContinuation { next in
    MoyaProvider<T>().request(kind) { result in
      switch result {
        case let .success(response):
//          Logger.log(response: response)
          let resultValue = try? JSONDecoder().decode(type, from: response.data)
          next.resume(returning: resultValue)
        case .failure(_):
          next.resume(returning: nil)
      }
    }
  }
}

extension ApiClient {
  enum MoyaService: TargetType {
    var baseURL: URL { URL(string: "https://github.com/login/oauth")! }
    var oauthURL: URL { URL(string: "https://github.com/login/oauth")! }

    case tokenWith(code: String, creds: GitHub.State.Credentials)

    var path: String {
      switch self {
        case .tokenWith: return "/access_token"
      }
    }
    var method: Moya.Method {
      switch self {
        case .tokenWith: return .post
      }
    }
    var task: Task {
      switch self {
        case let .tokenWith(code: code, creds: creds):
          return .requestParameters(parameters: [
            "client_id": creds.clientId,
            "client_secret" : creds.clientSecret,
            "code": code
          ], encoding: URLEncoding.default)
      }
    }
    var headers: [String : String]? {
      let result = ["Accept": "application/vnd.github+json"]
      return result
    }
  }
}


extension ApiClient: TestDependencyKey {
  static var failValue: ApiClient = .init { _, _ in
      .none
  }

  static var successValue: ApiClient = .init { _, _ in
      .some(.init(accessToken: "token", scope: "some scope", tokenType: "my type"))
  }
}

extension ApiClient: DependencyKey {
  static var liveValue: ApiClient = .init()
}

extension ApiClient {
  static var login = { (creds: GitHub.State.Credentials) in
    URL(string: "https://github.com/login/oauth/authorize?client_id=\(creds.clientId)")!
  }
}
