//
//  Tests.swift
//  Tests
//
//  Created by Артем Калинкин on 25.05.2023.
//

import ComposableArchitecture
import Moya
import XCTest

@testable import GitHub_App_Composable

@MainActor
final class SearchFeatureTests: XCTestCase {
  func testSearchingStarted() async {
    let store = TestStore(initialState: SearchReducer.State(), reducer: SearchReducer())
    store.dependencies.gitHubClient = .testValue

    await store.send(.set(\.$searchTextFieldText, "some")) {
      $0.searchTextFieldText = "some"
    }

    await store.finish(timeout: .seconds(1.5))

    await store.receive(.set(\.$isSearching, true)) {
      $0.isSearching = true
    }
  }
}

extension MoyaError: Equatable {
  public static func == (lhs: Moya.MoyaError, rhs: Moya.MoyaError) -> Bool {
    lhs.localizedDescription == rhs.localizedDescription
  }
}
