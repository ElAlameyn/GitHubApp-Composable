//
//  AsyncManager.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 20.02.2023.
//

import Combine
import Moya

struct AsyncManager {

  static func extract<T>(_ value: AsyncThrowingPublisher<AnyPublisher<T, Error>>) async -> T? {
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

  static func extractValues<T>( _ value: AsyncThrowingPublisher<AnyPublisher<T, Error>>) async throws -> T {
    try await withCheckedThrowingContinuation { next in
      async {
        do {
          for try await responseResult in value {
            print("Achieved values: \(responseResult)")
            next.resume(returning: responseResult)
          }
        } catch (let error) {
          next.resume(throwing: error)
        }
      }
    }
  }

}
