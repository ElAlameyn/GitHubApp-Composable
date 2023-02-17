//
//  AuthorizationFeatureClientMoyaService.swift
//  AuthorizationFeature-App-Composable
//
//  Created by Артем Калинкин on 11.02.2023.
//

import Moya
import Foundation


enum MoyaService {
  case tokenWith(code: String, clientId: String, clientSecret: String)
  case searchRepo(q: String)
}


extension MoyaService: TargetType {

  var baseURL: URL {
    switch self {
      case .tokenWith: return URL(string: "https://github.com/login/oauth")!
      default: return URL(string: "https://api.github.com")!
    }
  }

  var path: String {
    switch self {
      case .tokenWith: return "/access_token"
      case .searchRepo(let q): return "/search/repositories?q=\(q)"
    }
  }
  var method: Moya.Method {
    switch self {
      case .tokenWith: return .post
      case .searchRepo: return .get
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
      default: return .requestPlain
    }
  }

  var headers: [String : String]? {
    return ["Accept": "application/vnd.github+json"]
  }
}

extension MoyaService: AccessTokenAuthorizable {
  var authorizationType: Moya.AuthorizationType? {
    switch self {
      case .tokenWith: return nil
      default: return .bearer
    }
  }
}

