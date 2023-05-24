//
//  Moya+Extension.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 23.05.2023.
//

import Moya
import Foundation
import KeychainStored

extension Endpoint {
  static func withStubResponse<V: TargetType>(target: V, _ stubResponse: @escaping SampleResponseClosure) -> Endpoint {
    return Endpoint(
      url: URL(target: target).absoluteString,
      sampleResponseClosure: stubResponse,
      method: target.method,
      task: target.task,
      httpHeaderFields: target.headers
    )
  }
}

extension PluginType where Self == AccessTokenPlugin  {
  static var tokenPlugin: PluginType {
    AccessTokenPlugin { _ in
      @KeychainStored(service: "app-auth-token") var token: String?
      return token ?? ""
    }
  }
}
