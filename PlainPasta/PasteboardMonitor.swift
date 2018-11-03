// Created by Isaac Halvorson on 10/18/18

import Cocoa

protocol PasteboardMonitorDelegate: class {
	var enabledMenuItem: NSMenuItem { get }
}

class PasteboardMonitor {

	weak var delegate: PasteboardMonitorDelegate?

	private let pasteboard = NSPasteboard.general
	private var internalChangeCount = NSPasteboard.general.changeCount
	private var previousPasteboard: String?
	private var timer: Timer?

	init() {
		startTimer()
	}

	/// The current state of the pasteboard monitor
	///
	/// Defaults to `true` so that pasteboard monitoring starts immediately on app launch
	var enabledState: Bool = true {
		didSet { enabledState ? startTimer() : stopTimer() }
	}

	/// Starts monitoring the pasteboard, and sets the menu item's state to enabled
	private func startTimer() {
		delegate?.enabledMenuItem.state = .on
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
			self.checkPasteboard()
		}
	}

	/// Stops monitoring the pasteboard, and sets the menu item's state to disabled
	private func stopTimer() {
		delegate?.enabledMenuItem.state = .off
		timer?.invalidate()
	}

	/// Checks the pasteboard for textual contents, and strips the formatting if possible
	private func checkPasteboard() {

		// Check to see if the internal change counter is the same as the pasteboard's to prevent an infinite loop
		if internalChangeCount != pasteboard.changeCount {

			// Check to see if the item on the pasteboard is a file or directory, and exit if it is
			guard pasteboard.availableType(from: [.fileName]) == nil else { return }

			// Convert the pasteboard content into a plaintext string if possible
			guard let plaintextString = pasteboard.string(forType: .string) else { return }

			// Check that the plaintext string is not equal to what was previously on the pasteboard
			if plaintextString != previousPasteboard {

				// Update the previous pasteboard contents for future reference
				previousPasteboard = plaintextString

				// Update the pasteboard with our new plaintext representation
				pasteboard.clearContents()
				pasteboard.setString(plaintextString, forType: .string)

				internalChangeCount = pasteboard.changeCount

				// Log the string if app is running in debug mode
				#if DEBUG
				NSLog(plaintextString)
				#endif
			}
		}
	}

}

extension NSPasteboard.PasteboardType {

	/// The name of a file or directory
	///
	/// This extension gives access to the `NSFilenamesPboardType` PasteboardType that was removed in Swift 4.
	/// (via [this Stack Overflow answer](https://stackoverflow.com/a/46254276))
	///
	static let fileName: NSPasteboard.PasteboardType = {
		return NSPasteboard.PasteboardType("NSFilenamesPboardType")
	}()
}
