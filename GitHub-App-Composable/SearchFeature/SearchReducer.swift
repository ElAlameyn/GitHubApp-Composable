//
//  SearchState.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 16.02.2023.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct Repository: Equatable, Hashable {
  var name: String
  var stargazersCount: Int
}

struct SearchReducer: ReducerProtocol {
  struct State: Equatable {
    var repositories: [Repository] = Array<Repository>.init(repeating: .init(name: "MOck", stargazersCount: 1), count: 10)
    var isSearchFieldAppeared = false
    var isEmptySearchResponse = false
    @BindingState var isSearching = false
    @BindingState var searchTextFieldText: String = ""
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case searchButtonTapped
    case optionButtonTapped
    case repositoryItemTapped
    case searchResponse(TaskResult<RepositoriesResponse>)
    case onAppear
  }

  enum SearchID {}

  @Dependency(\.gitHubClient) var gitHubClient
  @Dependency(\.mainQueue) var mainQueue

  var body: some ReducerProtocol<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
        case .searchButtonTapped:
          state.isSearchFieldAppeared.toggle()
        case .optionButtonTapped, .repositoryItemTapped: break

        case .binding(\.$isSearching):
          print("Binded isSearchin: \(state.isSearching)")

        case .binding(\.$searchTextFieldText):
          let text = state.searchTextFieldText
          return .run { send in
            await send(.set(\.$isSearching, true))

            await send(.searchResponse(TaskResult {
              await gitHubClient
                .request(.searchRepo(q: text), of: RepositoriesResponse.self)
                .removeDuplicates()
                .eraseToAnyPublisher()
                .values
            }))

            await send(.set(\.$isSearching, false))
          }
          .debounce(id: SearchID.self, for: 0.5, scheduler: mainQueue)

        case .binding: return .none

        case .onAppear: break

        case .searchResponse(.success(let response)):
          state.isEmptySearchResponse = response.items.isEmpty

          state.repositories = response.items.map {
            Repository(
              name: $0.name,
              stargazersCount: $0.stargazersCount ?? 0
            )
          }
        case .searchResponse(.failure(let error)):
          print("Error: \(error.localizedDescription)")
          state.repositories = []
      }
      return .none
    }
  }
}
