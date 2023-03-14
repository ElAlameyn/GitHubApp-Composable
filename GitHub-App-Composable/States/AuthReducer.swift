//
//  AppState.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//

import Foundation
import ComposableArchitecture
import Combine
import Moya

struct AuthReducer: ReducerProtocol {

  struct State: Equatable {
    @BindingState var isAuthorized: Bool = false
    var isWebViewPresented: Bool = false
    var creds: Credentials = .init()

    struct Credentials: Equatable {
      var clientId = "Iv1.7c01457eab0c5039"
      var clientSecret = "79cda2e631bdeef3ed76c1f663dd61dc8325b25b"
    }
  }

  enum Action {
    case submitAuthButtonTapped
    case authorizedWith(tokenResponse: TokenResponse?)
    case tokenRequest(code: String, creds: State.Credentials)
    case tokenResponse(TaskResult<TokenResponse>)
    case isWebViewDismissed
  }

  @Dependency(\.gitHubClient) var gitHubClient

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
      case .submitAuthButtonTapped:
        state.isWebViewPresented = state.isAuthorized ? false : true
      case .authorizedWith: break
      case let .tokenRequest(code: code, creds: creds):

        return .task {
          await .tokenResponse(TaskResult {
            await gitHubClient
              .tokenRequest
              .run(.tokenWith(code: code, clientId: creds.clientId, clientSecret: creds.clientSecret))
              .values
          })
        }

      case .isWebViewDismissed:
        state.isWebViewPresented = false

      case .tokenResponse(.success(let response)):
        state.isAuthorized = true
        state.isWebViewPresented = false
        return .send(.authorizedWith(tokenResponse: response))

      case .tokenResponse(.failure(_)):
        state.isAuthorized = false
        state.isWebViewPresented = false
    }
    return .none
  }
}






