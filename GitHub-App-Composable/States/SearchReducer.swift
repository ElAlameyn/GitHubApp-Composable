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
    @BindingState var searchTextFieldText: String = ""
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case searchButtonTapped
    case exitButtonTapped
    case repositoryItemTapped
    case onSuccessSearchRequest(repos: [Repository])
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
        case .exitButtonTapped:
          break
        case .repositoryItemTapped:
          break

        case let .onSuccessSearchRequest(repos):
          state.repositories = repos
        case .binding(\.$searchTextFieldText):
          let text = state.searchTextFieldText
          return .run { send in

            async let value = await gitHubClient.searchRepos(
              .searchRepo(q: text)
            )
              .removeDuplicates()
              .eraseToAnyPublisher()

            do {
              for try await responseResult in await value.values {
                print("Achieved values: \(responseResult)")
                await send(.onSuccessSearchRequest(repos: responseResult.items.compactMap { Repository(name: $0.name) } ))
//                return responseResult
              }
            } catch (let error) {
              print("Error: \(error)")
            }
          }
          .debounce(id: SearchID.self, for: 0.5, scheduler: RunLoop.main)

//            if let responseResult = await AsyncManager.extract(value.values) {
//              print("Repos: \(responseResult.items.map { Repository(name: $0.name) })")
//              await send(.onSuccessSearchRequest(repos: responseResult.items.map { Repository(name: $0.name) }))
////              responseResult.items.
//            }
//          }

        case .binding(_): return .none

        case .onAppear:
          gitHubClient.setMoyaTokenClosure("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")
      }
      return .none
    }
  }
}

