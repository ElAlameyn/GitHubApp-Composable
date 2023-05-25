//
//  RepoVIew.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 25.05.2023.
//

import SwiftUI

struct RepoView: View {
  var title: String
  var starsCount: Int

  var body: some View {
    VStack {
      HStack(spacing: 0) {
        Image("repo")
          .resizable()
          .frame(width: 25, height: 40)
          .tint(.white)
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
              .padding(.trailing, 20)
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

