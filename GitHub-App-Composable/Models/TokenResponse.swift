//
//  TokenResponse.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 19.12.2022.
//

import Foundation

// MARK: - Welcome
struct TokenResponse: Codable {
  let accessToken, scope, tokenType: String

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case scope
    case tokenType = "token_type"
  }
}

extension TokenResponse {
  static let mock = Self(
    accessToken: "",
    scope: "",
    tokenType: ""
  )
}
