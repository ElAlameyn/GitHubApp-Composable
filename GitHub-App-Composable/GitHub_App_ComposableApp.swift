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
          GlobalAppView(store:
              .init(
                initialState: GlobalApp.State(),
                reducer: GlobalApp()
              )
          )

//          MeetView(store: StoreOf<AuthReducer>(
//            initialState: .init(),
//            reducer: AuthReducer())
//          )
        }
    }
}
