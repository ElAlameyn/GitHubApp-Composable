//
//  UserStateModels.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 26.05.2023.
//

import Foundation

extension UserReducer {
  struct AuthUserRepositories: Hashable {
    static let mock = Self(name: "Unowned")
    static let mocks = Array<AuthUserRepositories>(repeating: .mock, count: 10)

    var name: String = ""
  }

  struct UserAccount: Hashable {
    var name: String = ""
    var email: String?
    var linkToAccount: String = ""

    init(response: UserResponse) {
      name = response.login
      email = response.email
      linkToAccount = response.htmlUrl
    }

    init() {}

    init(name: String, email: String? = nil, linkToAccount: String) {
      self.name = name
      self.email = email
      self.linkToAccount = linkToAccount
    }

    static let mock = Self(
      name: "Blob Feld",
      email: "artem.k.3008@gmail.com",
      linkToAccount: "https://www.google.ru"
    )
  }
}
