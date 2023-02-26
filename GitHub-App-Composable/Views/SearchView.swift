//
//  SearchView.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 07.02.2023.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {

  let store: StoreOf<SearchReducer>
  @State var textFieldScaling = 0.0
  @FocusState var isSearchingFocused: Bool

  @Environment(\.dismiss) var dismiss

  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack {
          Button {
              viewStore.send(.searchButtonTapped)
            withAnimation {
              textFieldScaling = viewStore.isSearchFieldAppeared ? 1.0 : 0.0
            }
          } label: {
            Image(uiImage:
                .init(systemName: "magnifyingglass")!
              .withTintColor(.white, renderingMode: .alwaysOriginal)
              .resize(targetSize: .init(width: 45, height: 40))
            )
          }
          .padding()
          
          
          TextField(
            "Text",
            text: viewStore
              .binding(\.$searchTextFieldText)
              .removeDuplicates()
          )
          .focused($isSearchingFocused)
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
                  .init(systemName: "gearshape")!
                .withTintColor(.white, renderingMode: .alwaysOriginal)
                .resize(targetSize: .init(width: 45, height: 45))
              )
            }
            .padding()
          }
        }
        
        if !viewStore.repositories.isEmpty && !viewStore.isSearching {
          List {
            ForEach(viewStore.repositories, id: \.self) { repo in
              RepoView(title: repo.name, starsCount: repo.stargazersCount)
                .swipeActions {
                  Button {
                    //TODO: Add to favourites
                  } label: {
                    Label("Star", systemImage: "star.fill")
                  }
                  .tint(.yellow)
                }
            }
          }
          .scrollContentBackground(.hidden)
          .listStyle(.grouped)
          .padding(.top, -10)
        } else if !viewStore.isSearching || viewStore.searchTextFieldText.isEmpty {
          Spacer()
          Text(!viewStore.isEmptySearchResponse ? "Try to find some repos!" : "There is no repos with that name.")
            .font(.title2.bold())
            .foregroundColor(.white)
            .padding()

          Text(!viewStore.isEmptySearchResponse ? "Click to upside \"Search button\"" : "Find smth else.")
            .font(.footnote.bold())
            .foregroundColor(.white)
        } else {
          Spacer()
          ActivityIndicator(isAnimating: viewStore.binding(\.$isSearching), style: .large)
        }

        Spacer()

      }
      .navigationBarHidden(true)
      .background(Color.black.opacity(0.8))
      .onAppear {
//        viewStore.send(.onAppear)
      }
    }
  }
}

struct RepoView: View {

  var title: String
  var starsCount: Int

  var body: some View {
    VStack {
      HStack(spacing: 0) {
        Image(uiImage: .init(named: "repo")!
          .withTintColor(.white, renderingMode: .alwaysOriginal)
          .resize(targetSize: .init(width: 25, height: 40))
        )
        .padding(.leading, 10)
        .padding(.trailing, 15)

        Text(title)
          .font(.body)
          .foregroundColor(.white)
          .multilineTextAlignment(.leading)

        Spacer()

        VStack {
          Spacer()
          HStack(spacing: 3) {
            Spacer().frame(width: 10)
            Image(systemName: "star.fill")
              .foregroundColor(.yellow)
            Text("\(starsCount)")
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
