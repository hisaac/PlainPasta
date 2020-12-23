import AppKit
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	// MARK: - Initialization

	let pasteboardMonitor = PasteboardMonitor(for: NSPasteboard.general)
	let statusItemController = StatusItemController()

	// MARK: - AppDelegate Methods

	func applicationDidFinishLaunching(_ notification: Notification) {
		statusItemController.delegate = self
		statusItemController.enable()

		if Settings.firstLaunch {
			// Open settings window if this is the first launch
			#warning("Once settings window is implemented, open settings window if this is the first launch")
		}
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
		pasteboardMonitor.enable()
		statusItemController.enable()
		os_log(.info, "Plain Pasta has been enabled")
	}

	func disable() {
		pasteboardMonitor.disable()
		statusItemController.disable()
		os_log(.info, "Plain Pasta has been disabled")
	}
}
