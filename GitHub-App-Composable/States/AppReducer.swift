//
//  GlobalApp.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//

import Foundation
import ComposableArchitecture
import KeychainStored

struct AppReducer: ReducerProtocol {
  struct State: Equatable {
    @KeychainStored(service: "app-auth-token") var token: String?
    var authState: AuthReducer.State?
    var searchState: SearchReducer.State = .init()

    var nonNilAuthState: AuthReducer.State {
      get { authState ?? AuthReducer.State() }
      set { authState = newValue }
    }
  }

  enum Action {
    case quitApp
    case authorization(AuthReducer.Action)
    case searchAction(SearchReducer.Action)
    case checkIfTokenExpired
  }

  @Dependency(\.gitHubClient) var gitHubClient

  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.nonNilAuthState, action: /Action.authorization) { AuthReducer() }
    Scope(state: \.searchState, action: /Action.searchAction) { SearchReducer() }
    Reduce { state, action in
      switch action {
        case .quitApp:
          Logger.debug("Quit Action")
          exit(0)
        case let .authorization(.authorizedWith(token)):
          if let token {
            gitHubClient.setMoyaTokenClosure(token)
            state.token = token
          }

        case .authorization(.isWebViewDismissed):
          if let authState = state.authState, authState.isAuthorized {
            state.authState = nil
          }

        case .checkIfTokenExpired:
          break
          // check if token expired

//          state.authState = .init()
        case .authorization(_), .searchAction: break
      }
      return .none
    }
  }

}

