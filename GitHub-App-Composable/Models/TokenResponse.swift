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
}

extension TokenResponse {
  static let mock = Self(
    accessToken: "",
    scope: "",
    tokenType: ""
  )
}
