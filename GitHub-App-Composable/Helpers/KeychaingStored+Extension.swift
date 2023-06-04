//
//  ComposableAdaptive.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 15.02.2023.
//

import KeychainStored
import OrderedCollections

extension KeychainStored: Equatable {
  public static func == (lhs: KeychainStored<Value, ValueEncoder, ValueDecoder>, rhs: KeychainStored<Value, ValueEncoder, ValueDecoder>) -> Bool {
    lhs.service == rhs.service
  }
}

