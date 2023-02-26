//
//  UserReducer.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 25.02.2023.
//

import Foundation
import ComposableArchitecture

struct UserReducer: ReducerProtocol {

  struct State {

  }

  enum Action {

  }

  @Dependency(\.gitHubClient) var gitHubClient

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
        
    }
    return .none
  }
}
