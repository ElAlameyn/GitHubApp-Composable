//
//  GlobalApp.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//

import Foundation
import ComposableArchitecture

struct GlobalState: ReducerProtocol {
  struct State {
    var gitHubState: GitHub.State
  }

  enum Action {
    case quitApp
  }

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
      case .quitApp: exit(0)
    }
  }

}
