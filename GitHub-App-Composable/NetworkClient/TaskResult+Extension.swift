//
//  TaskResult+Extension.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 23.02.2023.
//

import ComposableArchitecture
import Combine
import Moya
import Foundation

extension TaskResult {
  public init(catching body: @Sendable () async throws -> AsyncThrowingPublisher<AnyPublisher<Success, Error>>) async {
    do {
      self = .success(try await AsyncManager.extractValues(body()))
    } catch {
      self = .failure(error)
    }
  }
}


extension TaskResult {
  static var error: Self {
    Self.failure(MoyaError.underlying(NSError.default, nil))
  }
}
