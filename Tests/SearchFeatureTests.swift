//
//  Tests.swift
//  Tests
//
//  Created by Артем Калинкин on 25.05.2023.
//

import ComposableArchitecture
@testable import GitHub_App_Composable
import Moya
import XCTest

@MainActor
final class SearchFeatureTests: XCTestCase {

  func testSearchingStarted() async {
    let store = TestStore(initialState: SearchReducer.State(), reducer: SearchReducer())
    store.dependencies.gitHubClient = .failValue
    store.dependencies.mainQueue = .immediate

    await store.send(.set(\.$searchTextFieldText, "some")) {
      $0.searchTextFieldText = "some"
    }

    await store.receive(.set(\.$isSearching, true)) {
      $0.isSearching = true
    }

    await store.receive(.set(\.$isSearching, false)) {
      $0.isSearching = false
    }
  }

  func testEmptyResponse() async {
    let store = TestStore(initialState: SearchReducer.State(), reducer: SearchReducer())
    store.dependencies.gitHubClient = .testValue
    store.dependencies.mainQueue = .immediate

    await store.send(.set(\.$searchTextFieldText, "some")) {
      $0.searchTextFieldText = "some"
    }

    await store.receive(.set(\.$isSearching, true)) {
      $0.isSearching = true
    }

    await store.receive(.searchResponse(.success(.init(totalCount: nil, incompleteResults: nil, items: [])))) {
      $0.isEmptySearchResponse = true
    }
    
    await store.receive(.set(\.$isSearching, false)) {
      $0.isSearching = false
    }
  }
}

extension MoyaError: Equatable {
  public static func == (lhs: Moya.MoyaError, rhs: Moya.MoyaError) -> Bool {
    lhs.localizedDescription == rhs.localizedDescription
  }
}
