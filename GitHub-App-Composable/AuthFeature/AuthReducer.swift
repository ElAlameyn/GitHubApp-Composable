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
    @BindingState var isAuthorized: Bool = false
    var isWebViewPresented: Bool = false
    var oauth: OAuth2Swift!
  }

  enum Action {
    case authorize
    case authorizedWith(tokenResponse: TokenResponse?)
    case onSuccessPreload(_ creds: SaveClient.Credentials)
    case tokenResponse(TaskResult<TokenResponse>)
  }

  @Dependency(\.gitHubClient) var gitHubClient
  @Dependency(\.saveClient) var saveClient

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
      case .authorizedWith: break

      case let .tokenResponse(.success(response)):
        state.isAuthorized = true
        return .send(.authorizedWith(tokenResponse: response))

      case let .tokenResponse(.failure(error)):
        state.isAuthorized = false
        // TODO: Add error handling
        print(error.localizedDescription)
      case .authorize:
        return .run { send in
          let value = await saveClient.preloadSecrets("BlobTag")
          if let value = value { await send(.onSuccessPreload(value)) }
        }

      case let .onSuccessPreload(creds):
        state.oauth = .init(
          consumerKey: creds.clientId,
          consumerSecret: creds.clientSecret,
          authorizeUrl: "https://github.com/login/oauth/authorize",
          accessTokenUrl: "https://github.com/login/oauth/access_token",
          responseType: "code"
        )

        state.oauth.authorizeURLHandler = OauthViewContoller()

        return .task { [oauth = state.oauth!] in
          await .tokenResponse(TaskResult {
            try await gitHubClient.authorize(oauth: oauth)
          })
        }
    }
    return .none
  }
}
