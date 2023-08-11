//
//  SaveClient.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 09.06.2023.
//

import ComposableArchitecture
import Logging
import UIKit


extension SaveClient {
  static var liveValue: SaveClient {
    let logger = Logger(label: "Save.Client 💽")

    return .init {
      let request = NSBundleResourceRequest(tags: Set([$0]))
      return try? await withCheckedThrowingContinuation { send in
        request.conditionallyBeginAccessingResources { isAvailable in
          if isAvailable {
            logger.info("Available")
            send.resume(returning: decodeCreds())
          } else {
            request.beginAccessingResources { error in
              if let error {
                send.resume(throwing: error)
              } else {
                logger.info("Donwloaded")
                send.resume(returning: decodeCreds())
              }
            }
          }
        }
      }
    }
  }
}

private func decodeCreds() -> SaveClient.Credentials {
  let data = NSDataAsset(name: "Secrets.json")!
  let decoded = try! JSONDecoder().decode(SaveClient.Credentials.self, from: data.data)
  return decoded
}
