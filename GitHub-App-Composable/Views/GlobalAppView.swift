//
//  GlobalAppView.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 12.02.2023.
//

import SwiftUI
import ComposableArchitecture

class Auth {
  var checkAuth: Bool = true
}

struct GlobalAppView: View {

  let store: StoreOf<GlobalApp>
  @State var viewStore: ViewStoreOf<GlobalApp>
  @State var checkAuth = true

  init(store: StoreOf<GlobalApp>) {
    self.store = store
    self.viewStore = ViewStoreOf<GlobalApp>(store)
  }

  var body: some View {
    NavigationView {

      // Check if token expired

      IfLetStore(
        store.scope(state: \.authState, action: GlobalApp.Action.authorization),
        then: {
          MeetView(store: $0)
        },
        else: {
          if checkAuth {
            Text("Checking Authorization.....")
          } else {
            SearchView()
          }
        }
      )
    }.onAppear {
      viewStore.send(.checkIfTokenExpired)
//      DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [self] in
//        self.checkAuth = false
//        viewStore.send(.checkIfTokenExpired)
//      })
    }
  }
}

struct GlobalAppView_Previews: PreviewProvider {
  static var previews: some View {
    GlobalAppView(store:
        .init(
          initialState: GlobalApp.State(),
          reducer: GlobalApp()
        )
    )
  }
}