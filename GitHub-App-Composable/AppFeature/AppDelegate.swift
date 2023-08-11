//
//  AppDelegate.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 05.06.2023.
//

import OAuthSwift
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    return true
  }


  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    print(url.string)
    OAuthSwift.handle(url: url)
    return true
  }

  class var sharedInstance: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
}
