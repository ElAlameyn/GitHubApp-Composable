//
//  SaveClient.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 09.06.2023.
//

import ComposableArchitecture
import UIKit

extension NSBundleResourceRequest: @unchecked Sendable {}

extension DependencyValues {
  var saveClient: SaveClient {
    get { self[SaveClient.self] }
    set { self[SaveClient.self] = newValue }
  }
}

struct SaveClient {
  struct Credentials: Equatable, Decodable {
    var clientId = ""
    var clientSecret = ""
  }

  func preloadSecrets(tag: String) async -> Credentials? {
    let request = NSBundleResourceRequest(tags: Set([tag]))
    return try? await withCheckedThrowingContinuation { send in
      request.conditionallyBeginAccessingResources { isAvailable in
        if isAvailable {
          print("Available")
          send.resume(returning: self.decodeCreds())
        } else {
          request.beginAccessingResources { error in
            if let error {
              send.resume(throwing: error)
            } else {
              print("Downloaded")
              send.resume(returning: self.decodeCreds())
            }
          }
        }
      }
    }
  }

  private func decodeCreds() -> Credentials {
    let data = NSDataAsset(name: "Secrets.json")!
    let decoded = try! JSONDecoder().decode(Credentials.self, from: data.data)

    print("Client id: \(decoded.clientId)")
    print("Client secret: \(decoded.clientSecret)")

    return decoded
  }
}

extension SaveClient {
  static var liveValue: SaveClient {
    return .init()
  }
}

extension SaveClient: TestDependencyKey {
  static var testValue: SaveClient {
    return .init()
  }
}
