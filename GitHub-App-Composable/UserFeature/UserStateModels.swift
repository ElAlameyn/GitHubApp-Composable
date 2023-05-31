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

    var name: String = ""
  }

  struct UserAccount: Hashable {
    static let mock = Self(
      name: "Blob Feld",
      email: "artem.k.3008@gmail.com",
      linkToAccount: "https://test/test/test/ElAlameyn"
    )

    var name: String = ""
    var email: String?
    var linkToAccount: String = ""
  }
}
