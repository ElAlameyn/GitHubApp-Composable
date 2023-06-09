//
//  GitHub_App_ComposableApp.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 11.02.2023.
//

import ComposableArchitecture
import SwiftUI

@main
struct GitHub_App_ComposableApp: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      // MARK: -  UserView

      //
//      NavigationView {
//        UserView(store: .init(
//          initialState: .init(),
//          reducer: UserReducer()
//            .dependency(\.gitHubClient, .failValue)
//        ))
//      }


//                SearchView(store: Store(initialState: .init(), reducer: SearchReducer()))

//                AuthView(store: StoreOf<AuthReducer>(
//                  initialState: .init(),
//                  reducer: AuthReducer()))


      AppView(store:
        .init(
          initialState: AppReducer.State(),
          reducer: AppReducer()
        )
      )

    }
  }
}
