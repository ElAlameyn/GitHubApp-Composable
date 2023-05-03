//
//  UserView.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 25.02.2023.
//

import SwiftUI
import ComposableArchitecture

struct UserView: View {
  let store: StoreOf<UserReducer>
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack(spacing: 0) {
          Image(uiImage: .init(named: "me")!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .frame(width: 160, height: 160)

          VStack(alignment: .leading, spacing: 10) {
            Text(viewStore.userAccount.name)
              .font(.system(size: 20).bold())
            viewStore.userAccount.email.map { Text($0) }

            // TODO: Open webView when link is tapped
            Text(viewStore.userAccount.linkToAccount)
              .font(.body)
              .minimumScaleFactor(0.01)
              .foregroundColor(.accentColor)
              .allowsTightening(true)
              .lineLimit(2)

            HStack {
              Image(systemName: "info.circle")
              Image(systemName: "person.3.sequence.fill")
              Image(systemName: "calendar.badge.clock")
            }
          }
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)

          Spacer()
        }


        HStack {
          Text("Repositories")
            .font(.system(size: 25).bold())
            .padding(.leading, 15)
          Spacer()
          VStack(spacing: 5) {
            Image(systemName: "person.circle")
              .font(.system(size: 25))
              .multilineTextAlignment(.center)
            Text("Owner")
              .font(.footnote)
          }
          .padding(.trailing)

          VStack(spacing: 5) {
            Image(systemName: "star.circle")
              .font(.system(size: 25))
              .multilineTextAlignment(.center)
            Text("Starred")
              .font(.footnote)
          }
          .padding(.trailing)
        }

        Divider()

        List {
          ForEach(0...4, id: \.self) { _ in
            Color.mint.frame(maxWidth: .infinity, maxHeight: 40)
              .listRowSeparator(.hidden)
          }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.grouped)
        .padding(.top, -15)

        Spacer()
      }
      .navigationTitle("User Account")
      .navigationBarTitleDisplayMode(.large)
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

struct UserView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UserView(store: .init(
        initialState: .init(userAccount: .mock),
        reducer: UserReducer()
      ))
    }
  }
}
