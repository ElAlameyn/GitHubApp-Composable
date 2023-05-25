//
//  AppView.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 12.02.2023.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
  let store: StoreOf<AppReducer>
  @ObservedObject var viewStore: ViewStoreOf<AppReducer>
  @State var checkAuth = false
  @State var selectedTab: TabBarView.Tab = .magnifyingglass
  
  init(store: StoreOf<AppReducer>) {
    self.store = store
    self.viewStore = ViewStoreOf<AppReducer>(store)
    UITabBar.appearance().isHidden = true
  }
  
  var body: some View {
    NavigationView {
      
      IfLetStore(
        store.scope(state: \.authState, action: AppReducer.Action.authorization),
        then: {
          AuthView(store: $0)
        },
        else: {
          ZStack {
            VStack(spacing: 0) {
              if checkAuth {
                Text("Checking Authorization.....")
              } else {
                TabView(selection: $selectedTab) {
                  switch selectedTab {
                    case .magnifyingglass:
                      SearchView(store: store.scope(
                        state: \.searchState,
                        action: AppReducer.Action.searchAction
                      ))
                        .tag(selectedTab)
                    case .star:
                      Color.green.ignoresSafeArea()
                        .tag(selectedTab)
                    case .person:
                      Color.blue.ignoresSafeArea()
                        .tag(selectedTab)
                  }
                }
              }
            }
            VStack {
              Spacer()
              TabBarView(selectedTab: $selectedTab)
            }
          }
        }
      )
    }
    .onAppear {
      viewStore.send(.checkIfTokenExpired)
    }
  }
}

struct TabBarView: View {
  enum Tab: String, CaseIterable {
    case magnifyingglass = "magnifyingglass.circle", star, person
    
    var fillImage: String { rawValue + ".fill"}
  }
  
  @Binding var selectedTab: Tab
  
  var body: some View {
    VStack {
      HStack {
        ForEach(Tab.allCases, id: \.rawValue) { tab in
          Spacer()
          Image(systemName: selectedTab == tab ? tab.fillImage : tab.rawValue)
            .scaleEffect(selectedTab == tab ? 1.6 : 1.0)
            .foregroundColor(.white)
            .font(.system(size: 25))
            .onTapGesture {
              withAnimation(.easeIn(duration: 0.1)) {
                selectedTab = tab
                print("Changed to :\(selectedTab)")
              }
            }
          Spacer()
        }
      }
      .frame(width: nil, height: 90)
      .background(Color.init(red: 38 / 255, green: 38 / 255, blue: 38 / 255).blur(radius: 10))
      .cornerRadius(20)
      .padding()
    }
  }
}

struct GlobalAppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store:
        .init(
          initialState: AppReducer.State(),
          reducer: AppReducer()
        )
    )
  }
}
