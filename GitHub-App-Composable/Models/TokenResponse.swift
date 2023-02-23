//
//  TokenResponse.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 19.12.2022.
//

import Foundation

// MARK: - TokenResponse
struct TokenResponse: Codable {
  let accessToken, scope, tokenType: String
  let expiresIn: Int
  let refreshToken: String
  let refreshTokenExpiresIn: Int
}

extension TokenResponse {
  static let mock = Self(
    accessToken: "",
    scope: "",
    tokenType: "",
    expiresIn: 0,
    refreshToken: "",
    refreshTokenExpiresIn: 0
  )
}
