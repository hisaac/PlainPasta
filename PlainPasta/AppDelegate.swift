import AppKit
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	// MARK: - Initialization

	let pasteboardMonitor = PasteboardMonitor(for: NSPasteboard.general)
	let statusItemController = StatusItemController()

	private (set) var isEnabled = false

	// MARK: - AppDelegate Methods

	func applicationDidFinishLaunching(_ notification: Notification) {
		statusItemController.delegate = self
		enable()
	}
}

extension AppDelegate: Enablable {
	func enable() {
		guard isEnabled == false else { return }
		isEnabled = true
		pasteboardMonitor.enable()
		statusItemController.enable()
		os_log("%@", type: .info, "Plain Pasta has been enabled")
	}

	func disable() {
		guard isEnabled == true else { return }
		isEnabled = false
		pasteboardMonitor.disable()
		statusItemController.disable()
		os_log("%@", type: .info, "Plain Pasta has been disabled")
	}
}
