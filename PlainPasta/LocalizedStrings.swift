import Foundation

/// Localized strings and their default values used by Plain Pasta
enum LocalizedStrings {

	// MARK: - Menu Item Titles

	/// Localized version of "About Plain Pasta…"
	/// For use as the title for the "About Plain Pasta…" menu item
	static let aboutPlainPastaMenuItem = NSLocalizedString(
		"aboutPlainPastaMenuItem",
		value: "About Plain Pasta…",
		comment: #"Title for the "About" menu item"#
	)

	/// Localized version of "Enabled"
	/// For use as the title for the "Enabled" menu item
	static let enabledMenuItem = NSLocalizedString(
		"enabledMenuItem",
		value: "Enabled",
		comment: #"Title for the "Enabled" menu item"#
	)

	/// Localized version of "Quit"
	/// For use as the title for the "Quit" menu item
	static let quitMenuItem = NSLocalizedString(
		"quitMenuItem",
		value: "Quit",
		comment: #"Title for the "Quit" menu item"#
	)

	// MARK: - Version Number

	/// Localized version of the word "Version"
	/// For use in representing the app's version number
	static let versionTitle = NSLocalizedString(
		"versionTitle",
		value: "Version",
		comment: "The word for 'Version'"
	)

	/// Localized version of the word "build"
	/// For use in representing the app's build number
	static let buildTitle = NSLocalizedString(
		"buildTitle",
		value: "build",
		comment: "The word for 'build'"
	)

	/// Localized version of the app's full version and build number
	/// Formatted as: "Version 1.0.1 (build 12)"
	static var appVersion: String {
		let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
		let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"
		return "\(versionTitle) \(versionNumber) (\(buildTitle) \(buildNumber))"
	}
}
