//
//  Client.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 09.06.2023.
//

import ComposableArchitecture
import Foundation

struct SaveClient {
  var preloadSecrets: (_ tag: String) async -> Credentials?

  struct Credentials: Equatable, Decodable {
    var clientId = ""
    var clientSecret = ""
  }
}

extension NSBundleResourceRequest: @unchecked Sendable {}
