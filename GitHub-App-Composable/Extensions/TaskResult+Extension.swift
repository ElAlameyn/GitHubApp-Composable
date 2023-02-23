//
//  TaskResult+Extension.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 23.02.2023.
//

import ComposableArchitecture
import Combine
import Moya

extension TaskResult {
  public init(catching body: @Sendable () async throws -> AsyncThrowingPublisher<AnyPublisher<Success, Error>>) async {
    do {
      self = .success(try await AsyncManager.extractValues(body()))
    } catch {
      self = .failure(error)
    }
  }
}
