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
    var userAccount: UserAccount = .init()
    var userRepositories: [AuthUserRepositories] = .init(repeating: .mock, count: 10)
    var repositoryShowOption: RepositoryShowOption = .owner
    var alert: AlertState<Action>?
  }

  enum Action: BindableAction, Equatable {
    case onAppear
    case authUserAccountResponse(TaskResult<UserResponse>)
    case authUserRepositoriesResponse(TaskResult<[GithubRepository]>)
    case changeRepositoryFilter(State.RepositoryShowOption)
    case binding(BindingAction<State>)
    case dismissAlert
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
          state.alert = AlertState(
            title: TextState("Ooops! Some error occured"),
            message: .init(error.localizedDescription),
            dismissButton: .default(TextState("Ok"), action: .send(.dismissAlert))
          )
        case .binding: break
        case .dismissAlert: state.alert = nil
      }
      return .none
    }
  }
}
