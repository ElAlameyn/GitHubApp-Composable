//
//  UserView.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 25.02.2023.
//

import ComposableArchitecture
import SwiftUI

struct UserView: View {
  // MARK: Lifecycle

  init(store: StoreOf<UserReducer>) {
    self.store = store
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
  }

  // MARK: Internal

  let store: StoreOf<UserReducer>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationStack {
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
                .foregroundColor(viewStore.repositoryShowOption == .owner ? Color.red : .white)
                .onTapGesture { viewStore.send(.changeRepositoryFilter(.owner)) }
              Text("Owner")
                .font(.footnote)
            }
            .padding(.trailing)


            VStack(spacing: 5) {
              Image(systemName: "star.circle")
                .font(.system(size: 25))
                .multilineTextAlignment(.center)
                .onTapGesture { viewStore.send(.changeRepositoryFilter(.starred)) }
                .foregroundColor(viewStore.repositoryShowOption == .starred ? Color.red : .white)
              Text("Starred")
                .font(.footnote)
            }
            .padding(.trailing)
          }

          Divider()

          List {
            ForEach(viewStore.userRepositories, id: \.self) { repo in
              VStack {
                HStack {
                  Text(repo.name)
                    .padding(.leading, 10)
                  Spacer()
                }
                Divider()
                  .overlay(.white)
              }
              .listRowSeparator(.hidden)
              .listRowBackground(Color.clear)
            }
          }
          .scrollContentBackground(.hidden)
          .listStyle(.inset)

          Spacer()
        }
        .onAppear { viewStore.send(.onAppear) }
        .blackTheme()
        .alert(isPresented: viewStore.binding(\.alertState.$isErrorAlertPresented), content: {
          Alert(title: Text(viewStore.alertState.text))
        })
      }
      .foregroundColor(Color.white)
      .navigationBarTitleDisplayMode(.large)
      .navigationTitle("User Account")
    }
  }
}

struct UserView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UserView(store: .init(
        initialState: .init(userAccount: .mock),
        reducer: UserReducer()
//          .dependency(\.gitHubClient, .failValue)
      ))
    }
  }
}
