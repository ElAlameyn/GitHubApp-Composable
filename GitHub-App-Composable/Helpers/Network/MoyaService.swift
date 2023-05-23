//
//  AuthorizationFeatureClientMoyaService.swift
//  AuthorizationFeature-App-Composable
//
//  Created by Артем Калинкин on 11.02.2023.
//

import Foundation
import Moya

enum MoyaService {
  case tokenWith(code: String, clientId: String, clientSecret: String)
  case authUser
  case searchRepo(q: String)
  case authUserRepos
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
      case .searchRepo: return "/search/repositories"
      case .authUser: return "/user"
      case .authUserRepos: return "/user/repos"
    }
  }

  var method: Moya.Method {
    switch self {
      case .tokenWith: return .post
      case .searchRepo, .authUser, .authUserRepos: return .get
    }
  }

  var task: Task {
    switch self {
      case .tokenWith(code: let code, clientId: let clientId, clientSecret: let clientSecret):
        return .requestParameters(parameters: [
          "client_id": clientId,
          "client_secret": clientSecret,
          "code": code
        ], encoding: URLEncoding.default)
      case .searchRepo(q: let q):
        return .requestParameters(parameters: ["q": q], encoding: URLEncoding.default)
      case .authUser, .authUserRepos: return .requestPlain
    }
  }

  var headers: [String: String]? {
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
