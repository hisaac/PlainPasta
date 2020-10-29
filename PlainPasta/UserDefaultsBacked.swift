// Created by Isaac Halvorson on 10/29/20

import Foundation

/// Simple property wrapper for UserDefaults
///
/// Based off of John Sundell's [Property wrappers in Swift article](https://swiftbysundell.com/articles/property-wrappers-in-swift/)
@propertyWrapper
struct UserDefaultsBacked<T> {
	private let key: String
	private let defaultValue: T

	init(key: String, defaultValue: T) {
		self.key = key
		self.defaultValue = defaultValue
	}

	var wrappedValue: T {
		get {
			let value = UserDefaults.standard.object(forKey: key) as? T
			return value ?? defaultValue
		}
		set {
			if let optional = newValue as? AnyOptional, optional.isNil {
				UserDefaults.standard.removeObject(forKey: key)
			} else {
				UserDefaults.standard.setValue(newValue, forKey: key)
			}
		}
	}
}

// Add ability to define a default value of `nil` by not providing a `defaultValue`
extension UserDefaultsBacked where T: ExpressibleByNilLiteral {
	init(key: String) {
		self.init(key: key, defaultValue: nil)
	}
}

// The protocol and extension below allow for our `UserDefaultsBacked` property wrapper to handle `nil` values,
// even though the `T` type isn't technically optional.

private protocol AnyOptional {
	var isNil: Bool { get }
}

extension Optional: AnyOptional {
	var isNil: Bool { self == nil }
}
