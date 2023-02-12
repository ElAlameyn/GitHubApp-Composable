//
//  Logger.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//

import ComposableArchitecture
import Moya
import Foundation

struct Logger {
  static func log<Root: ReducerProtocol, Value>(
    label: String = "Debug Print",
    viewStore: ViewStoreOf<Root>,
    kp: KeyPath<Root.State, Value>
  )  {
    print((label) + "\(viewStore.state[keyPath: kp])")
  }

  static func log(response: Response)  {
    print("=============🔥 RESPONSE 🔥===============")
    let json = try? JSONSerialization.jsonObject(with: response.data, options: .fragmentsAllowed)
    print(json ?? "Not serialized")
    print("Status code: \(response.statusCode)")
    print("=============🔥==========🔥===============")
  }
}

