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

struct Repository: Equatable {
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
    case searchRepos
    case onAppear
  }

  @Dependency(\.gitHubClient) var gitHubClient


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
        case .searchRepos:
          let text = state.searchTextFieldText
          return .run { _ in
            print("Called")

            async let value = await gitHubClient.searchRepos(
              .searchRepo(q: text)
            )
              .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
              .eraseToAnyPublisher()

            if let responseResult = await AsyncManager.extract(value.values) {

            }
          }
//            print("Requested: \(MoyaService.searchRepo(q: "K"))")
//            MoyaService.searchRepo(q: "s").authorizationType?.value
        case .binding(\.$searchTextFieldText):
          return .run { send in
            await send(.searchRepos)
          }

        case .binding(_): return .none

        case .onAppear:
          gitHubClient.setMoyaTokenClosure("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")
      }
      return .none
    }
  }
}

