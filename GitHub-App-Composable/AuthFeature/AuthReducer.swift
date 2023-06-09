//
//  AppState.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//

import Combine
import ComposableArchitecture
import Foundation
import Moya
import OAuthSwift
import UIKit

struct AuthReducer: ReducerProtocol {
  struct State: Equatable {
    struct Credentials: Equatable {
      var clientId = "Iv1.7c01457eab0c5039"
      var clientSecret = "79cda2e631bdeef3ed76c1f663dd61dc8325b25b"
    }

    @BindingState var isAuthorized: Bool = false
    var isWebViewPresented: Bool = false
    var creds: Credentials = .init()
  }

  enum Action {
    case submitAuthButtonTapped
    case authorizedWith(tokenResponse: TokenResponse?)
    case authorize
    case tokenResponse(TaskResult<TokenResponse>)
    case isWebViewDismissed
  }

  @Dependency(\.gitHubClient) var gitHubClient

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
      case .submitAuthButtonTapped:
        state.isWebViewPresented = state.isAuthorized ? false : true
      case .authorizedWith: break
      case .authorize:
        return .task {
          await .tokenResponse(TaskResult {
            try await gitHubClient.authorize()
          })
        }

      case .isWebViewDismissed:
        state.isWebViewPresented = false

      case let .tokenResponse(.success(response)):
        state.isAuthorized = true
        state.isWebViewPresented = false
        return .send(.authorizedWith(tokenResponse: response))

      case let .tokenResponse(.failure(error)):
        state.isAuthorized = false
        state.isWebViewPresented = false
        print(error.localizedDescription)
    }
    return .none
  }
}
