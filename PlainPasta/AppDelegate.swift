import AppKit
import Defaults
import os.log
import Preferences
import SwiftUI

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

	// MARK: - Initialization

	var window: NSWindow?
	var pasteboardMonitor: PasteboardMonitor?
	var statusItemController: StatusItemController?

	#warning("TODO: Create custom logger class that uses `Logger` or `OSLog` depending on the operating system")
	// https://developer.apple.com/documentation/os/logging/generating_log_messages_from_your_code
	// https://nshipster.com/swift-log/
	let logger: OSLog = {
		let subsystem = Bundle.main.bundleIdentifier!
		let category = #file
		return OSLog(subsystem: subsystem, category: category)
	}()

	lazy var preferencesWindowController = PreferencesWindowController(
		panes: [
			Preferences.Pane(
				identifier: .general,
				title: "General",
				toolbarIcon: NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General Preferences")!,
				contentView: { GeneralPreferencesView() }
			),
			Preferences.Pane(
				identifier: .keyboardShortcuts,
				title: "Keyboard Shortcuts",
				toolbarIcon: NSImage(systemSymbolName: "keyboard", accessibilityDescription: "Keyboard Shortcuts Preferences")!,
				contentView: { KeyboardShortcutsPreferencesView() }
			),
			Preferences.Pane(
				identifier: .debugging,
				title: "Debugging",
				toolbarIcon: NSImage(systemSymbolName: "ladybug", accessibilityDescription: "Debugging Preferences")!,
				contentView: { DebuggingPreferencesView() }
			)
		],
		animated: false
	)

	// MARK: - AppDelegate Methods

	func applicationDidFinishLaunching(_ notification: Notification) {
		pasteboardMonitor = PasteboardMonitor(for: NSPasteboard.general, logger: logger)

		statusItemController = StatusItemController(logger: logger)
		statusItemController?.delegate = self

		if Defaults[.firstLaunch] {
			// Open settings window if this is the first launch
			openPreferencesWindow()
		}
		Defaults[.firstLaunch] = false

		#if DEBUG
		Defaults[.debugEnabled] = true
		if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
			openPreferencesWindow()
		}
		#endif
	}
}

protocol PreferencesWindowDelegate: AnyObject {
	func openPreferencesWindow()
}

extension AppDelegate: PreferencesWindowDelegate {
	func openPreferencesWindow() {
		preferencesWindowController.show()
	}
}
