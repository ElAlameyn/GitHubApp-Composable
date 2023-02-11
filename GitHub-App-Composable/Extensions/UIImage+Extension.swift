//
//  UIImage.swift
//  GitHub_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//

import UIKit

extension UIImage {
  func resize(targetSize: CGSize) -> UIImage {
    return UIGraphicsImageRenderer(size:targetSize).image { _ in
      self.draw(in: CGRect(origin: .zero, size: targetSize))
    }
  }
}
