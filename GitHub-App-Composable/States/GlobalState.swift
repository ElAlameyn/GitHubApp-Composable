//
//  GlobalApp.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//

import Foundation
import ComposableArchitecture


struct GlobalApp: ReducerProtocol {
  struct State: Equatable {
    var authState: AuthReducer.State?

    var nonNilAuthState: AuthReducer.State {
      get { authState ?? AuthReducer.State() }
      set { authState = newValue }
    }
  }

  enum Action {
    case quitApp
    case authorization(AuthReducer.Action)
    case checkIfTokenExpired
  }

  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.nonNilAuthState, action: /Action.authorization) {
      AuthReducer()
    }
    Reduce { state, action in
      switch action {
        case .quitApp:
          Logger.debug("Quit Action")
          exit(0)
        case .authorization(_):
          Logger.debug("Auth Action")
        case .checkIfTokenExpired:
//          state.authState?.isAuthorized = true
          state.authState = .init()
      }
      return .none
    }
  }

}

