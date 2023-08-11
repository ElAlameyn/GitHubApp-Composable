//
//  TestKey.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 09.06.2023.
//

import ComposableArchitecture

extension DependencyValues {
  var saveClient: SaveClient {
    get { self[SaveClient.self] }
    set { self[SaveClient.self] = newValue }
  }
}

extension SaveClient: TestDependencyKey {
  static var testValue: SaveClient {
    return .init(preloadSecrets: { _ in
      return .init(Credentials(clientId: "test", clientSecret: "test"))
    })
  }
}
