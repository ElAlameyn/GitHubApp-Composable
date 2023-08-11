//
//  GlobalApp.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//

import ComposableArchitecture
import Foundation
import KeychainStored
import Logging


///Token Expired ghu_X2aoim5NzvPdRjYmFFZYEvkXLbWguK138B36

struct AppReducer: ReducerProtocol {
  struct State: Equatable {
    @KeychainStored(service: "app-auth-token") var token: String?
    @KeychainStored(service: "app-auth-token-response") var tokenModel: ExpirationTokenModel?
    var authState: AuthReducer.State? = nil
    var searchState: SearchReducer.State = .init()
    var userState: UserReducer.State = .init()
    var alert: AlertState<AlertAction>?
  }

  enum AlertAction: Equatable {
    case dismiss
  }

  enum Action {
    case quitApp
    case authorization(AuthReducer.Action)
    case searchAction(SearchReducer.Action)
    case userAction(UserReducer.Action)
    case checkIfTokenExpired
    case alert(AlertAction)
  }

  @Dependency(\.gitHubClient) var gitHubClient
  @Dependency(\.logger) var logger

  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.searchState, action: /Action.searchAction) { SearchReducer() }
    Scope(state: \.userState, action: /Action.userAction) { UserReducer() }
    Reduce { state, action in
      switch action {
        case let .authorization(.authorizedWith(tokenResponse)):
          saveTokenInfo(tokenResponse, state: &state)
          state.authState = nil

        case .checkIfTokenExpired:
          state.authState = .init()
//          checkTokenExpiration(state: &state)

        case .userAction(.authUserRepositoriesResponse(.failure(let error))),
            .userAction(.authUserAccountResponse(.failure(let error))),
            .searchAction(.searchResponse(.failure(let error))),
            .authorization(.tokenResponse(.failure(let error))):

          logger.error("\(error)")
          logger.debug("That's okey")


          state.alert = AlertState(
            title: TextState("Ooops! Some error occured"),
            message: .init(error.localizedDescription),
            dismissButton: .default(TextState("Ok"), action: .send(.dismiss))
          )

        case .searchAction: break
        case .userAction: break
        case .authorization: break
        case .alert(.dismiss): state.alert = nil
        case .quitApp: exit(0)
      }
      return .none
    }
    .ifLet(\.authState, action: /Action.authorization, then: { AuthReducer() })
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
      logger.debug("Token After: \(tokenResponse.accessToken)")
      state.token = tokenResponse.accessToken
      state.tokenModel = .init(response: tokenResponse, savedDate: Date())
    }
  }
}
