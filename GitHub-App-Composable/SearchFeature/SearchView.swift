//
//  SearchView.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 07.02.2023.
//

import ComposableArchitecture
import SwiftUI

struct SearchView: View {
  let store: StoreOf<SearchReducer>
  @State var textFieldScaling = 0.0
  @FocusState var isSearchingFocused: Bool

  @Environment(\.dismiss) var dismiss

  private func shouldDisplayGear(_ viewStore: ViewStoreOf<SearchReducer>) -> Bool { !viewStore.isSearchFieldAppeared }

  private func shouldDisplaySearchedRepos(_ viewStore: ViewStoreOf<SearchReducer>) -> Bool {
    !viewStore.repositories.isEmpty && !viewStore.isSearching
  }

  private func shouldDisplayEmptyResponseMessage(_ viewStore: ViewStoreOf<SearchReducer>) -> Bool {
    !viewStore.isSearching || viewStore.searchTextFieldText.isEmpty
  }

  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack {
          Button {
            viewStore.send(.searchButtonTapped)
            withAnimation { textFieldScaling = viewStore.isSearchFieldAppeared ? 1.0 : 0.0 }
          } label: {
            Image(systemName: "magnifyingglass")
              .resizable()
              .frame(width: 40, height: 40)
          }
          .padding()
          .onAppear {
            print("hi")
          }

          TextField("Text", text: viewStore
            .binding(\.$searchTextFieldText)
            .removeDuplicates())
            .focused($isSearchingFocused)
            .padding(.leading)
            .padding(.trailing, 60)
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .scaleEffect(textFieldScaling)
            .overlay {
              if !viewStore.isSearchFieldAppeared {
                Text("Explore and find Repositories on Git")
                  .font(.title2.bold())
                  .multilineTextAlignment(.center)
                  .lineLimit(nil)
                  .fixedSize(horizontal: false, vertical: true)
              }
            }
            .onAppear {
              print("hi")
            }

          !viewStore.isSearchFieldAppeared ? Spacer() : Spacer(minLength: 30)

          if shouldDisplayGear(viewStore) {
            Button {
              print("Okey")
              dismiss()
            } label: {
              Image(systemName: "gearshape")
                .resizable()
                .frame(width: 45, height: 45)
            }
            .padding()
          }
        }

        if isSearchingFocused {

          VStack {
            ForEach(0 ..< 3) { id in

              Button {
                print("Tapped")
              } label: {
                Text("buenos tardes man \(id)")
                  .padding()
              }
            }
            .foregroundColor(.red)
          }
        }

        if shouldDisplaySearchedRepos(viewStore) {
          List {
            ForEach(viewStore.repositories, id: \.self) { repo in
              RepoView(title: repo.name, starsCount: repo.stargazersCount)
                .swipeActions {
                  Button {
                    // TODO: Add to favourites
                  } label: {
                    Label("Star", systemImage: "star.fill")
                  }
                  .tint(.yellow)
                }
            }
          }
          .zIndex(0)
          .scrollContentBackground(.hidden)
          .listStyle(.grouped)
          .padding(.top, -10)
        } else if shouldDisplayEmptyResponseMessage(viewStore) {
          Spacer()
          Text(!viewStore.isEmptySearchResponse ? "Try to find some repos!" : "There is no repos with that name.")
            .font(.title2.bold())
            .padding()

          Text(!viewStore.isEmptySearchResponse ? "Click to upside \"Search button\"" : "Find smth else.")
            .font(.footnote.bold())
        } else {
          Spacer()
          ActivityIndicator(isAnimating: viewStore.binding(\.$isSearching), style: .large)
        }

        Spacer()
      }
      .foregroundColor(.white)
      .navigationBarHidden(true)
      .background(Color.black.opacity(0.8))
    }
  } // ViewStore
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(store: Store(initialState: .init(), reducer: SearchReducer()))
  }
}
