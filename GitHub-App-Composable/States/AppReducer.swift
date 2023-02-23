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
    @KeychainStored(service: "app-auth-token-response") var tokenModel: ExpirationTokenModel?
    var authState: AuthReducer.State? = nil
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
        case let .authorization(.authorizedWith(tokenResponse)):
          // Saving tokens
          saveTokenInfo(tokenResponse, state: &state)

        case .authorization(.isWebViewDismissed):
          if let authState = state.authState, authState.isAuthorized {
            state.authState = nil
          }

        case .checkIfTokenExpired:
          // Checking if should present auth view

          state.authState = .init()
//          checkTokenExpiration(state: &state)


        case .authorization(_), .searchAction: break
      }
      return .none
    }
  }

  // TODO: Create some saving client

  private func checkTokenExpiration(state: inout State) {
    if let tokenModel = state.tokenModel {
      state.authState = tokenModel.isExpiredBy(currentDate: Date()) ? .init() : nil
    } else {
      state.authState = .init()
    }
  }

  private func saveTokenInfo(_ tokenResponse: TokenResponse?, state: inout State) {
    if let tokenResponse {
      state.token = tokenResponse.accessToken
      state.tokenModel = .init(response: tokenResponse, savedDate: Date())
    }
  }

}

