//
//  AppState.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//

import Foundation
import ComposableArchitecture


struct Users: Equatable {}

struct GitHub: ReducerProtocol {

  struct State: Equatable {
    @BindingState var isAuthorized: Bool = false
    var users: [Users] = []
    var isWebViewPresented: Bool = false
    var creds: Credentials = .init()


    struct Credentials: Equatable {
      var clientId = "19aeb2677ede1f813ccc"
      var clientSecret = "813e4e4f5ae96ac0dab36870933e2b89966e86e7"
    }
  }

  enum Action {
    case submitAuthButtonTapped
    case authorized(Bool)
    case tokenRequest(code: String, creds: State.Credentials)
    case isWebViewDismissed
  }

  @Dependency(\.gitHubClient) var gitHubClient

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
      case .submitAuthButtonTapped:
        state.isWebViewPresented = true
      case let .authorized(isAuthorized):
        state.isAuthorized = isAuthorized
        state.isWebViewPresented = false
      case let .tokenRequest(code: code, creds: creds):
        return .run { send in
          async let value = gitHubClient
            .requestToken(
              .tokenWith(code: code, creds: creds)
            )

          await send(.authorized(try value.get() != nil))
        }
        case .isWebViewDismissed: state.isWebViewPresented = false
    }
    return .none
  }

}


