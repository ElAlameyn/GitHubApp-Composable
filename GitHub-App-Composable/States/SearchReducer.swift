//
//  SearchState.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 16.02.2023.
//

import ComposableArchitecture
import Foundation
import SwiftUI

//struct Repository: Decodable, Equatable { }

struct Repository: Equatable, Hashable {
  var name: String
}

struct SearchReducer: ReducerProtocol {

  struct State: Equatable {
    var repositories: [Repository] = []
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
    case onSuccessSearchRequest(repos: [Repository])
    case onEmptyResponse
    case onAppear
  }

  @Dependency(\.gitHubClient) var gitHubClient


  enum SearchID {}

  var body: some ReducerProtocol<State, Action> {
    BindingReducer()

    Reduce { state, action in

      switch action {
        case .searchButtonTapped:
          state.isSearchFieldAppeared.toggle()
        case .optionButtonTapped, .repositoryItemTapped:
          break

        case let .onSuccessSearchRequest(repos):
          state.repositories = repos
        case .binding(\.$isSearching):
          print("Binded isSearchin: \(state.isSearching)")
          break

        case .binding(\.$searchTextFieldText):
          let text = state.searchTextFieldText
          return .run { send in

            await send(.set(\.$isSearching, true))

            async let value = await gitHubClient
              .searchRequest
              .run(.searchRepo(q: text))
              .removeDuplicates()
              .eraseToAnyPublisher()

            if let responseResult = await AsyncManager.extract(value.values) {

              await send(.onSuccessSearchRequest(repos: responseResult.items.map { Repository(name: $0.name) }))
              if responseResult.items.isEmpty { await send(.onEmptyResponse) }

              await send(.set(\.$isSearching, false))
            }
          }
          .debounce(id: SearchID.self, for: 0.5, scheduler: RunLoop.main)

        case .binding(_): return .none

        case .onAppear: break
//          gitHubClient.setToken("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")

        case .onEmptyResponse:
          state.isEmptySearchResponse = true

      }
      return .none
    }
  }
}

