//
//  SavingClient.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 01.06.2023.
//

import Foundation

// MARK: - Equatable

extension Cache: Equatable {
  static func == (lhs: Cache<Key, Value>, rhs: Cache<Key, Value>) -> Bool {
    lhs.wrapped == rhs.wrapped
  }
}

// MARK: - Main Functions

final class Cache<Key: Hashable, Value> {
  private let wrapped: NSCache<WrappedKey, Entry> = {
    let wrapped = NSCache<WrappedKey, Entry>()
    wrapped.evictsObjectsWithDiscardedContent = false
    return wrapped
  }()

  func insert(_ value: Value, forKey key: Key) {
    let entry = Entry(value: value)
    wrapped.setObject(entry, forKey: WrappedKey(key))
  }

  func value(forKey key: Key) -> Value? {
    let entry = wrapped.object(forKey: WrappedKey(key))
    return entry?.value
  }

  func removeValue(forKey key: Key) {
    wrapped.removeObject(forKey: WrappedKey(key))
  }
}

// MARK: - Wrapped Key

private extension Cache {
  final class WrappedKey: NSObject {
    let key: Key

    init(_ key: Key) { self.key = key }

    override var hash: Int { key.hashValue }

    override func isEqual(_ object: Any?) -> Bool {
      guard let value = object as? WrappedKey else { return false }
      return value.key == key
    }
  }
}

// MARK: - Entry

private extension Cache {
  final class Entry: NSDiscardableContent {
    let value: Value

    init(value: Value) { self.value = value }

    public func beginContentAccess() -> Bool { true }

    public func endContentAccess() {}
    
    public func discardContentIfPossible() {}

    public func isContentDiscarded() -> Bool { false }
  }
}

// MARK: - Subscripting

extension Cache {
  subscript(key: Key) -> Value? {
    get { return value(forKey: key) }
    set {
      guard let value = newValue else {
        removeValue(forKey: key)
        return
      }

      insert(value, forKey: key)
    }
  }
}
