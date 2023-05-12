//
//  UserReducer.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 25.02.2023.
//

import ComposableArchitecture
import Foundation

struct UserReducer: ReducerProtocol {
  struct State: Equatable {
    var userAccount: UserAccount = .init()
    var userRepositories: [AuthUserRepositories] = .init(repeating: .mock, count: 10)
  }

  enum Action {
    case onAppear
    case userResponse(TaskResult<UserResponse>)
    case userRepositoryResponse(TaskResult<[GithubRepository]>)
  }

  @Dependency(\.gitHubClient) var gitHubClient

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
      case .onAppear:
        // TODO: User Account request
        /// Display them

        return .run { send in
          await withTaskGroup(of: Void.self, body: { group in
            group.addTask {
              await send(.userResponse(TaskResult {
                await gitHubClient
                  .request(.authUser, of: UserResponse.self)
                  .values
              }))
            }

            group.addTask {
              await send(.userRepositoryResponse(TaskResult {
                await gitHubClient
                  .request(.authUserRepos, of: [GithubRepository].self)
                  .values
              }))
            }
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
      case .userRepositoryResponse(.success(let userRepositoriesReponse)):
        state.userRepositories = userRepositoriesReponse.map { AuthUserRepositories(name: $0.name) }

      case .userRepositoryResponse(.failure(let error)):
        print("User error: \(error.localizedDescription)")
    }
    return .none
  }
}

extension UserReducer {
  struct AuthUserRepositories: Hashable {
    var name: String = ""

    static let mock = Self(name: "Unowned")
  }

  struct UserAccount: Hashable {
    static let mock = Self(
      name: "Blob Feld",
      email: "artem.k.3008@gmail.com",
      linkToAccount: "https://test/test/test/ElAlameyn"
    )

    var name: String = ""
    var email: String?
    var linkToAccount: String = ""
  }
}
