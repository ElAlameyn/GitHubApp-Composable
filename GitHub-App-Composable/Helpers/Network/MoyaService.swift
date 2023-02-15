//
//  AuthorizationFeatureClientMoyaService.swift
//  AuthorizationFeature-App-Composable
//
//  Created by Артем Калинкин on 11.02.2023.
//

import Moya
import Foundation

enum MoyaService: TargetType {
  var baseURL: URL {
    switch self {
      case .tokenWith: return URL(string: "https://github.com/login/oauth")!
    }
  }

  case tokenWith(code: String, clientId: String, clientSecret: String)

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
      case let .tokenWith(code: code, clientId: clientId, clientSecret: clientSecret):
        return .requestParameters(parameters: [
          "client_id": clientId,
          "client_secret" : clientSecret,
          "code": code
        ], encoding: URLEncoding.default)
    }
  }
  var headers: [String : String]? {
    return ["Accept": "application/vnd.github+json"]
  }
}

