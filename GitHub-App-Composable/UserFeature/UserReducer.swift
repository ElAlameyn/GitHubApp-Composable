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
    enum RepositoryShowOption { case owner, starred }

    struct AlertState: Equatable {
      @BindingState var isErrorAlertPresented = false
      var text: String = "Some error occured"
    }

    var userAccount: UserAccount = .init()
    var userRepositories: [AuthUserRepositories] = .init(repeating: .mock, count: 10)
    var repositoryShowOption: RepositoryShowOption = .owner
    var alertState: AlertState = .init()
  }

  enum Action: BindableAction, Equatable {
    case onAppear
    case authUserAccountResponse(TaskResult<UserResponse>)
    case authUserRepositoriesResponse(TaskResult<[GithubRepository]>)
    case changeRepositoryFilter(State.RepositoryShowOption)
    case binding(BindingAction<State>)
  }

  @Dependency(\.gitHubClient) var gitHubClient

  var body: some ReducerProtocol<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
        case .onAppear:
          return .run { send in
            await withTaskGroup(of: Void.self, body: { group in
              group.addTask {
                await send(.authUserAccountResponse(TaskResult {
                  await gitHubClient
                    .request(.authUserAccount, of: UserResponse.self)
                    .values
                }))
              }

              group.addTask {
                await send(.authUserRepositoriesResponse(TaskResult {
                  await gitHubClient
                    .request(.authUserRepos, of: [GithubRepository].self)
                    .values
                }))
              }
            })
          }

        case .authUserAccountResponse(.success(let userResponse)):
          state.userAccount = .init(
            name: userResponse.login,
            email: userResponse.email,
            linkToAccount: userResponse.htmlUrl 
          )
          print("User response: \(userResponse)")
        case .changeRepositoryFilter(let option): state.repositoryShowOption = option
        case .authUserRepositoriesResponse(.success(let userRepositoriesReponse)):
          state.userRepositories = userRepositoriesReponse.map { AuthUserRepositories(name: $0.name) }
        case .authUserRepositoriesResponse(.failure(let error)),
             .authUserAccountResponse(.failure(let error)):
          state.alertState.isErrorAlertPresented = true
          state.alertState.text = error.localizedDescription
        case .binding: break
      }
      return .none
    }
  }
}

extension UserReducer {
  struct AuthUserRepositories: Hashable {
    static let mock = Self(name: "Unowned")

    var name: String = ""
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
