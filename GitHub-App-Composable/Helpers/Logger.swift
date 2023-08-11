//
//  Logger.swift
//  AuthorizationFeature_Finder_Composable
//
//  Created by Артем Калинкин on 17.12.2022.
//

import ComposableArchitecture
import Foundation
import Logging
import Moya

extension Logger {
  static func log(response: Response) {
    print("=============🔥 RESPONSE 🔥===============")
    let json = try? JSONSerialization.jsonObject(with: response.data, options: .fragmentsAllowed)
    print(json ?? "Not serialized")
    print("Status code: \(response.statusCode)")
    print("=============🔥==========🔥===============")
  }

  static func log(data: Data, statusCode: Int) {
    print("=============🔥 RESPONSE 🔥===============")
    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
    print(json ?? "Not serialized")
    print("Status code: \(statusCode)")
    print("=============🔥==========🔥===============")
  }

  @inlinable
  public func error(
    _ message: @autoclosure () -> Logger.Message,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
  ) {
    self.error("🛑 Error 🛑: \(message()) ©️", metadata: nil, source: nil, file: file, function: function, line: line)
  }

  @inlinable
  public func debug(
    _ message: @autoclosure () -> Logger.Message,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
  ) {
    self.debug("🟢 Debug 🟢: \(message()) ©️", metadata: nil, source: nil, file: file, function: function, line: line)
  }
}

extension DependencyValues {
  var logger: Logger {
    get { self[Logger.self] }
    set { self[Logger.self] = newValue }
  }
}

extension Logger: DependencyKey {
  public static var liveValue: Logging.Logger {
    var logger = Logger.init(label: "logger")
    logger.logLevel = .debug
    return logger
  }
}
