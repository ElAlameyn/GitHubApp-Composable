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

    VStack {
      HStack {
        Image(uiImage: .init(named: "me")!)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
          .frame(width: 200, height: 200)

        VStack(alignment: .leading, spacing: 15) {
          Text("Name")
          Text("Email")
          Text("Link to account")

          HStack {
            Image(systemName: "info.circle")
            Image(systemName: "person.3.sequence.fill")
            Image(systemName: "calendar.badge.clock")
          }
        }
        .padding(.trailing, 20)
        .multilineTextAlignment(.leading)
        Spacer()
      }


      HStack {
        Text("Repositories")
          .font(.system(size: 25).bold())
          .padding(.leading, 15)
        Spacer()
      }

      Divider()

      List {
        ForEach(0...4, id: \.self) { _ in
          Color.mint.frame(width: .infinity, height: 40)
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
  }
}

struct UserView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UserView(store: .init(
        initialState: .init(),
        reducer: UserReducer()
      ))
    }
  }
}
