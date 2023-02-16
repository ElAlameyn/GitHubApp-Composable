//
//  GlobalAppView.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 12.02.2023.
//

import SwiftUI
import ComposableArchitecture

struct GlobalAppView: View {

  let store: StoreOf<GlobalApp>
  @State var viewStore: ViewStoreOf<GlobalApp>
  @State var checkAuth = false

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
            SearchView(store: store.scope(state: \.searchState, action: GlobalApp.Action.searchAction))
          }
        }
      )
    }.onAppear {
      viewStore.send(.checkIfTokenExpired)
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
