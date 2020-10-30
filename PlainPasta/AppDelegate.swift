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

		if Settings.firstLaunch {
			isEnabled = true

			// Open settings window if this is the first launch
			#warning("Open settings window if this is the first launch")
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
		guard isEnabled == false else { return }
		isEnabled = true
		pasteboardMonitor.enable()
		statusItemController.enable()
		os_log(.info, "Plain Pasta has been enabled")
	}

	func disable() {
		guard isEnabled == true else { return }
		isEnabled = false
		pasteboardMonitor.disable()
		statusItemController.disable()
		os_log(.info, "Plain Pasta has been disabled")
	}
}
