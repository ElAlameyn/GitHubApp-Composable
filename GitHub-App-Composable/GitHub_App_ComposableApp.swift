//
//  GitHub_App_ComposableApp.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 11.02.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct GitHub_App_ComposableApp: App {
    var body: some Scene {
        WindowGroup {

          // MARK: -  UserView
//          NavigationView {
//            UserView(store: .init(
//              initialState: .init(),
//              reducer: UserReducer()
//            ))
//          }

          // MARK: - Search View
//          SearchView(store: Store(initialState: .init(), reducer: SearchReducer()))

          // MARK: - App View
            AppView(store:
                .init(
                  initialState: AppReducer.State(),
                  reducer: AppReducer()
                    .dependency(\.gitHubClient, .failValue)
                )
            )


          // MARK: - Meet View
//          MeetView(store: StoreOf<AuthReducer>(
//            initialState: .init(),
//            reducer: AuthReducer())
//          )
        }
    }
}
