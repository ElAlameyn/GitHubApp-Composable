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
      var clientId = "19aeb2677ede1f813ccc"
      var clientSecret = "813e4e4f5ae96ac0dab36870933e2b89966e86e7"
    }
  }

  enum Action {
    case submitAuthButtonTapped
    case authorizedWith(token: String?)
    case tokenRequest(code: String, creds: State.Credentials)
    case isWebViewDismissed
  }

  @Dependency(\.gitHubClient) var gitHubClient

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    Logger.debug("\(action)")
    switch action {
      case .submitAuthButtonTapped:
        state.isWebViewPresented = state.isAuthorized ? false : true
      case let .authorizedWith(token):
        state.isAuthorized = token != nil
        state.isWebViewPresented = false
      case let .tokenRequest(code: code, creds: creds):

        return .run { send in
          async let value = await gitHubClient.requestToken(
            .tokenWith(code: code, clientId: creds.clientId, clientSecret: creds.clientSecret)
          )

//          if let responseResult = await AsyncManager.extract(value.values) {
//              await send(.authorizedWith(token: responseResult.accessToken))
//          } else {
//            await send(.authorizedWith(token: nil))
//          }

          do {
            for try await responseResult in await value.values {
              print("Achieved values: \(responseResult)")
              await send(.authorizedWith(token: responseResult.accessToken))
            }
          } catch (let error) {
            await send(.authorizedWith(token: nil))
            print("Error: \(error)")
          }

        }

      case .isWebViewDismissed:
        state.isWebViewPresented = false
    }
    return .none
  }
}




struct AsyncManager {

  static func extract<T>(_ value: AsyncThrowingPublisher<AnyPublisher<T, MoyaError>>) async -> T? {
    do {
      for try await responseResult in value {
        print("Achieved values: \(responseResult)")
        return responseResult
      }
    } catch (let error) {
      print("Error: \(error)")
    }
    return nil
  }
}
