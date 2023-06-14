//
//  Logger.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//
import Logging
import Moya
import Foundation


extension Logger {
  static func log(response: Response)  {
        print("=============🔥 RESPONSE 🔥===============")
        let json = try? JSONSerialization.jsonObject(with: response.data, options: .fragmentsAllowed)
        print(json ?? "Not serialized")
        print("Status code: \(response.statusCode)")
        print("=============🔥==========🔥===============")
      }
}
