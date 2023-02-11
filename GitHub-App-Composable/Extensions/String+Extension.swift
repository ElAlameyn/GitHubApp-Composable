//
//  String+Extension.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 06.02.2023.
//

import Foundation

extension String {
  func underline() -> AttributedString {
    var attributed = AttributedString(self)
    attributed.underlineStyle = .single
    return attributed
  }
}
