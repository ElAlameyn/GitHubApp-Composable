//
//  SearchView.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 07.02.2023.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {

  @State var textFieldScaling = 0.0
  let store: StoreOf<SearchReducer>
//  @State var viewStore: ViewStoreOf<GlobalApp>
  @State var text: String = ""

  @Environment(\.dismiss) var dismiss

  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack {
          Button {
            withAnimation {
              viewStore.send(.searchButtonTapped)
              textFieldScaling = viewStore.isSearchFieldAppeared ? 1.0 : 0.0
            }
          } label: {
            Image(uiImage:
                .init(systemName: "magnifyingglass.circle")!
              .withTintColor(.white, renderingMode: .alwaysOriginal)
              .resize(targetSize: .init(width: 50, height: 50))
            )
          }
          .padding()


          TextField("Text", text: viewStore
            .binding(\.$searchTextFieldText)
            .removeDuplicates()
          )
//            .uniqueUpdates())
            .padding(.leading)
            .padding(.trailing, 60)
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(.white)
            .cornerRadius(10)
            .scaleEffect(textFieldScaling)
            .overlay {
              if !viewStore.isSearchFieldAppeared {
                Text("Explore and find Repositories on Git")
                  .font(.title2.bold())
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .lineLimit(nil)
                  .fixedSize(horizontal: false, vertical: true)
              }
            }

          !viewStore.isSearchFieldAppeared ? Spacer() : Spacer(minLength: 30)

          if !viewStore.isSearchFieldAppeared {
            Button {
              dismiss()
            } label: {
              Image(uiImage:
                  .init(systemName: "rectangle.portrait.and.arrow.forward")!
                .withTintColor(.white, renderingMode: .alwaysOriginal)
                .resize(targetSize: .init(width: 45, height: 40))
              )
            }
            .padding()
          }
        }

        List {
          ForEach((1...10), id: \.self) {_ in
            RepoView()
          }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.grouped)
        .padding(.top, -10)

        Spacer()
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
    .navigationBarHidden(true)
    .background(Color.black.opacity(0.8))
  }
}

struct RepoView: View {
  var body: some View {
    VStack {
      HStack(spacing: 0) {
        Image(uiImage: .init(named: "repo")!
          .withTintColor(.white, renderingMode: .alwaysOriginal)
          .resize(targetSize: .init(width: 25, height: 40))
        )
        .padding(.leading, 10)
        .padding(.trailing, 10)

        VStack {
          Text("GitHub repo for you smflajxl  js sfjaf")
            .font(.body)
            .foregroundColor(.white)

          HStack {
            Spacer()
            Text("Stars: ")
              .font(.footnote)
              .foregroundColor(.white)
              .padding(.trailing , 20)
              .padding(.top, 1)
          }
        }
      }
      Divider()
        .overlay(.white)
        .frame(maxWidth: .infinity)
    }
    .listRowBackground(Color.clear)
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(store: Store(initialState: .init(), reducer: SearchReducer()))
  }
}
