//
//  SearchState.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 16.02.2023.
//

import ComposableArchitecture

struct Repository: Decodable, Equatable { }

struct SearchReducer: ReducerProtocol {

  struct State: Equatable {
    var repositories: [Repository] = []
    var isSearchFieldAppeared = false
  }

  enum Action {
    case searchButtonTapped
    case exitButtonTapped
    case repositoryItemTapped
  }

  func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
    switch action {
      case .searchButtonTapped:
        state.isSearchFieldAppeared.toggle()
      case .exitButtonTapped:
        break
      case .repositoryItemTapped:
        break
    }
    return .none
  }
}
