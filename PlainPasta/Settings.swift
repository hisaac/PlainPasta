// Created by Isaac Halvorson on 10/29/20

import Foundation

struct Settings {
	/// Sets whether debug mode is enabled
	@UserDefaultsBacked(key: "debugEnabled", defaultValue: false)
	static var debugEnabled: Bool

	/// Sets whether pasteboard filtering is enabled
	@UserDefaultsBacked(key: "filteringEnabled", defaultValue: false)
	static var filteringEnabled: Bool

	/// Tracks if this is the first time the app has been launched
	@UserDefaultsBacked(key: "firstLaunch", defaultValue: true)
	static var firstLaunch: Bool
}
