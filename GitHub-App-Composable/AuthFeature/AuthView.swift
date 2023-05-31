//
//  ContentView.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 15.12.2022.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct AuthView: View {
//  @State private var isLinkActive = false
  @Environment(\.dismiss) var dismiss
  let store: StoreOf<AuthReducer>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack {
          Spacer().frame(width: 10)
          Image(uiImage: .init(
            named: "small-logo")!
            .withTintColor(.white, renderingMode: .alwaysOriginal)
            .resize(targetSize: .init(width: 40, height: 40))
          )
          .padding()
          Spacer()
        }
        VStack(spacing: 20) {
          HStack {
            Spacer()
            Image(uiImage: .init(named: "logo-standard")!
              .withTintColor(.white, renderingMode: .alwaysOriginal)
              .resize(targetSize: .init(width: 300, height: 300)))
          }

          HStack {
            Spacer()
            Text("Search for folders and files! Find what you want")
              .font(.system(.title))
              .multilineTextAlignment(.trailing)
              .foregroundColor(Color(uiColor: .white))
              .padding()
          }

          HStack {
            Spacer()

            Button {
              viewStore.send(.submitAuthButtonTapped)
            } label: {
              Text("Get Started")
                .frame(minWidth: 200, minHeight: 40)
                .background(.white)
                .font(.title.bold())
                .cornerRadius(20)
                .foregroundStyle(LinearGradient(
                  colors: [.red, .purple],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                ))
                .padding()
            }
          }
        }

        Spacer()

        VStack(spacing: -20) {
          Text("Already have an account?\n")
          Text("Sign with Google".underline())
        }
        .multilineTextAlignment(.center)
        .foregroundColor(.white)

      }
      .blackTheme()
      .sheet(isPresented: viewStore.binding(
        get: \.isWebViewPresented,
        send: .isWebViewDismissed)
      ) {
        WebView(
          url: GitHubClient.getOauthURL(clientId: viewStore.creds.clientId),
          type: .codeExtract
        ) { code in viewStore.send(
          .tokenRequest(
            code: code,
            creds: viewStore.creds
          ))
        }
        .onDisappear {
          if viewStore.isAuthorized { dismiss() }
        }
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AuthView(store: StoreOf<AuthReducer>(
      initialState: .init(),
      reducer: AuthReducer()
    )
    )
  }
}





