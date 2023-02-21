//
//  AsyncManager.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 20.02.2023.
//

import Combine
import Moya

struct AsyncManager {

  static func extract<T>(_ value: AsyncThrowingPublisher<AnyPublisher<T, MoyaError>>) async -> T? {
    do {
      for try await responseResult in value {
        print("Achieved values: \(responseResult)")
        return responseResult
      }
    } catch (let error) {
      print("Error: \(error)")
    }
    return nil
  }
}
