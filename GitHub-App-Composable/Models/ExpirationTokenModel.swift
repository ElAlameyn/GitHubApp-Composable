//
//  TokenModel.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 23.02.2023.
//

import Foundation

struct ExpirationTokenModel: Codable {
  let response: TokenResponse
  let savedDate: Date

  func isExpiredBy(currentDate: Date) -> Bool {
    Int(currentDate - savedDate) >= response.expiresIn
  }
}

extension Date {
  static func - (lhs: Date, rhs: Date) -> TimeInterval {
    return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
  }
}
