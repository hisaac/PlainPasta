// Created by Isaac Halvorson on 2020-10-29

import Defaults
import Foundation

extension Defaults.Keys {
	/// Whether debug mode is enabled
	static let debugEnabled = Key<Bool>("debugEnabled", default: false)

	/// Whether pasteboard filtering is enabled
	static let filteringEnabled = Key<Bool>("filteringEnabled", default: false)

	/// Tracks if this is the first time the app has been launched
	static let firstLaunch = Key<Bool>("firstLaunch", default: true)

	/// Whether or not to hide the menu item from the menu bar
	static let hideMenuItem = Key<Bool>("hideMenuItem", default: false)

	static let leftClickBehavior = Key<LeftClickBehavior>("leftClickBehavior", default: .openMenu)
}

extension Defaults {
	static func resetToDefaults() {
		reset([.debugEnabled, .filteringEnabled, .firstLaunch, .hideMenuItem, .leftClickBehavior])
	}
}

enum LeftClickBehavior: String, Codable {
	case openMenu
	case toggleFiltering
}
