//
//  SearchView.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 07.02.2023.
//

import SwiftUI

struct SearchView: View {

  @State var isSearchButtonTapped = false
  @State var textFieldScaling = 0.0

  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack {
      HStack {
        Button {
          withAnimation {
            isSearchButtonTapped.toggle()
            textFieldScaling = isSearchButtonTapped ? 1.0 : 0.0
          }
        } label: {
          Image(uiImage:
              .init(systemName: "magnifyingglass.circle")!
            .withTintColor(.white, renderingMode: .alwaysOriginal)
            .resize(targetSize: .init(width: 50, height: 50))
          )
        }
        .padding()

        TextField("Text", text: .constant("OK"))
          .padding(.leading)
          .frame(maxWidth: .infinity, minHeight: 40)
          .background(.white)
          .cornerRadius(10)
          .scaleEffect(textFieldScaling)

        Spacer()

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

      Spacer()
    }
    .navigationBarHidden(true)
    .background(Color.black.opacity(0.8))
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView()
  }
}
