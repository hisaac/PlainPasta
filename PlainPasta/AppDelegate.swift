import AppKit
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

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

	// MARK: - AppDelegate Methods

	func applicationDidFinishLaunching(_ notification: Notification) {
		pasteboardMonitor = PasteboardMonitor(for: NSPasteboard.general, logger: logger)

		statusItemController = StatusItemController(logger: logger)
		statusItemController?.delegate = self
		statusItemController?.enable()

		if Settings.firstLaunch {
			// Open settings window if this is the first launch
			#warning("TODO: Once settings window is implemented, open settings window if this is the first launch")
		}

		#if DEBUG
		openPreferencesWindow()
		Settings.debugEnabled = true
		#endif
	}
}

extension AppDelegate: Enablable {

	private(set) var isEnabled: Bool {
		get { Settings.filteringEnabled }
		set {
			Settings.filteringEnabled = newValue
			if newValue {
				enable()
			} else {
				disable()
			}
		}
	}

	func enable() {
		pasteboardMonitor?.enable()
		statusItemController?.enable()
		os_log(.info, log: logger, "Plain Pasta has been enabled")
	}

	func disable() {
		pasteboardMonitor?.disable()
		statusItemController?.disable()
		os_log(.info, log: logger, "Plain Pasta has been disabled")
	}
}

extension AppDelegate: PreferencesWindowDelegate {
	func openPreferencesWindow() {
		NSApp.activate(ignoringOtherApps: true)
		let generalPreferencesViewController = GeneralPreferencesViewController()
		let contentView = window?.contentView
		contentView?.addSubview(generalPreferencesViewController.view)
	}
}
