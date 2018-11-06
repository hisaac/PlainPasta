// Created by Isaac Halvorson on 10/18/18

import AppKit
import os.log

protocol PasteboardMonitorDelegate: class {
	var enabledMenuItem: NSMenuItem { get }
}

class PasteboardMonitor {

	weak var delegate: PasteboardMonitorDelegate?

	private let pasteboard = NSPasteboard.general
	private var internalChangeCount = NSPasteboard.general.changeCount
	private var previousPasteboard: String?
	private var timer = DispatchSource.makeTimerSource()

	init() {
		startTimer()
	}

	deinit {
		stopTimer()
	}

	/// The current state of the pasteboard monitor
	var enabledState: Bool = true {
		didSet { enabledState ? startTimer() : stopTimer() }
	}

	/// Starts monitoring the pasteboard, and sets the menu item's state to enabled
	private func startTimer() {
		delegate?.enabledMenuItem.state = .on

		timer.schedule(deadline: .now(), repeating: .milliseconds(100))
		timer.setEventHandler { [weak self] in
			self?.checkPasteboard()
		}
		timer.resume()
	}

	/// Stops monitoring the pasteboard, and sets the menu item's state to disabled
	private func stopTimer() {
		delegate?.enabledMenuItem.state = .off
		timer.cancel()
	}

	/// Checks the pasteboard for textual contents, and strips the formatting if possible
	private func checkPasteboard() {
		if internalChangeCount != pasteboard.changeCount {

			// Check to see if the item on the pasteboard is a file or directory, and exit if it is
			guard pasteboard.availableType(from: [.fileName]) == nil else { return }

			// Convert the pasteboard content into a plaintext string if possible
			guard let plaintextString = pasteboard.string(forType: .string) else { return }

			if plaintextString != previousPasteboard {
				previousPasteboard = plaintextString
				pasteboard.clearContents()
				pasteboard.setString(plaintextString, forType: .string)

				internalChangeCount = pasteboard.changeCount

				if #available(OSX 10.14, *) {
					os_log(.info, "plaintext pasteboard content: %@", plaintextString)
				} else {
					os_log("plaintext pasteboard content: %@", log: .default, type: .info, plaintextString)
				}
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
