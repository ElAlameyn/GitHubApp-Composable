//
//  UserReducer.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 25.02.2023.
//

import Foundation
import ComposableArchitecture

struct UserAccount: Equatable & Hashable {
  var name: String = ""
  var email: String?
  var linkToAccount: String = ""
}

extension UserAccount {
  static let mock = Self(
    name: "Blob Feld",
    email: "artem.k.3008@gmail.com",
    linkToAccount: "https://test/test/test/ElAlameyn"
  )
}

struct UserReducer: ReducerProtocol {

  struct State: Equatable {
    var userAccount: UserAccount = .init()
  }

  enum Action {
    case onAppear
    case userResponse(TaskResult<UserResponse>)
  }

  @Dependency(\.gitHubClient) var gitHubClient

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
      case .onAppear:
        //TODO: User Account request
        /// Add User model
        /// Make request to user
        /// Display Info
        /// Make request to userRepos
        /// Combine requests
        /// Display them

        return .task {
          await .userResponse(TaskResult {
            await gitHubClient
              .userRequest
              .run(.authUser)
              .values
          })
        }

      case .userResponse(.success(let userResponse)):
        state.userAccount = .init(
          name: userResponse.login,
          email: userResponse.email,
          linkToAccount: userResponse.htmlUrl
        )
        print("User response: \(userResponse)")
      case .userResponse(.failure(let error)):
        print("User error: \(error.localizedDescription)")
        break
    }
    return .none
  }
}
