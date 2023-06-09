//
//  UserReducer.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 25.02.2023.
//

import ComposableArchitecture
import Foundation
import KeychainStored
import OrderedCollections

struct UserReducer: ReducerProtocol {
  struct State: Equatable {
    var userAccount: UserAccount = .init()
    var userRepositories: [AuthUserRepositories] = []
    var cachedRepositories = Cache<GithubRepository.ID, GithubRepository>()
    var repositoryShowOption: RepositoryShowOption = .owner
    var alert: AlertState<Action>?
    @BindingState var isSheetPresented: Bool = false
    @KeychainStored(service: "authUser-repos-ids") var repoIDs: OrderedSet<GithubRepository.ID>?

    enum RepositoryShowOption { case owner, starred }
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

          guard !tryLoadCachedReposFrom(&state) else { return .none }

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
          state.userAccount = .init(response: userResponse)
          print("User response: \(userResponse)")
        case .changeRepositoryFilter(let option): state.repositoryShowOption = option
        case .authUserRepositoriesResponse(.success(let userRepositoriesReponse)):
          state.userRepositories = userRepositoriesReponse.map { AuthUserRepositories(name: $0.name) }
          userRepositoriesReponse.forEach { state.cachedRepositories[$0.id] = $0 }
          state.repoIDs = OrderedSet(userRepositoriesReponse.map(\.id))
        case .authUserRepositoriesResponse(.failure(let error)),
             .authUserAccountResponse(.failure(let error)):

          state.alert = AlertState(
            title: TextState("Ooops! Some error occured"),
            message: .init(error.localizedDescription),
            dismissButton: .default(TextState("Ok"), action: .send(.dismissAlert))
          )

          tryLoadCachedReposFrom(&state)

        case .binding: break
        case .dismissAlert: state.alert = nil
      }
      return .none
    }
  }

  @discardableResult
  func tryLoadCachedReposFrom(_ state: inout State) -> Bool {
    state.userRepositories = state.repoIDs?.elements
      .compactMap { id in state.cachedRepositories[id] ?? nil }
      .map { AuthUserRepositories(name: $0.name) } ?? []

    return !state.userRepositories.isEmpty
  }
}
