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
//          SearchView(store: Store(initialState: .init(), reducer: SearchReducer()))
          AppView(store:
              .init(
                initialState: AppReducer.State(authState: .init()),
                reducer: AppReducer()
              )
          )

//          MeetView(store: StoreOf<AuthReducer>(
//            initialState: .init(),
//            reducer: AuthReducer())
//          )
        }
    }
}
