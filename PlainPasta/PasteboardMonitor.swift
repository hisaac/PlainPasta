import AppKit
import os.log

class PasteboardMonitor {

	/// The pasteboard to monitor
	let pasteboard: NSPasteboard

	/// The change count used to compare to the given pasteboard's change count
	/// Initially set to the given pasteboard's change count
	private var internalChangeCount: Int

	private var timer = DispatchSource.makeTimerSource()

	private (set) var isEnabled = false

	let logger: OSLog

	/// All of the types of pasteboard data to filter out when copying pasteboard data
	static let pasteboardTypeFilterList: [NSPasteboard.PasteboardType] = [
		.html,
		.rtf,
		.rtfd,
		NSPasteboard.PasteboardType("com.apple.webarchive"),
		NSPasteboard.PasteboardType("CorePasteboardFlavorType 0x75726C6E"),
		NSPasteboard.PasteboardType("public.url-name"),
		NSPasteboard.PasteboardType("public.utf16-external-plain-text"),
		NSPasteboard.PasteboardType("WebURLsWithTitlesPboardType"),
		NSPasteboard.PasteboardType("com.apple.WebKit.custom-pasteboard-data")
	]

	init(for pasteboard: NSPasteboard, logger: OSLog) {
		self.pasteboard = pasteboard
		self.logger = logger

		internalChangeCount = pasteboard.changeCount

		timer.schedule(deadline: .now(), repeating: .milliseconds(100))
		timer.setEventHandler { [weak self] in
			guard let strongSelf = self else { return }
			strongSelf.checkPasteboard(strongSelf.pasteboard)
		}
	}

	deinit {
		timer.setEventHandler {}
		timer.cancel()

		// Weirdly, due to a known bug in `DispatchSourceTimer`,
		// you have to resume the timer after cancelling it in order to avoid a crash. 🤦‍♂️
		timer.resume()
	}

	/// Checks the pasteboard for styled text contents, and strips the formatting if possible
	/// - Parameter pasteboard: The pasteboard to check and write to if necessary
	func checkPasteboard(_ pasteboard: NSPasteboard) {
		guard internalChangeCount != pasteboard.changeCount else { return }

		if let pasteboardItem = pasteboard.pasteboardItems?.first,
		   let plaintextString = pasteboardItem.string(forType: .string) {

			let filteredPasteboardItem = pasteboardItem.plaintextifiedCopy()

			if Settings.debugEnabled {
				// Print out pasteboard types for help in debugging
				let debugString: StaticString =
					"""
					Pasteboard types before filtering:\n
					%{public}@\n
					\n
					Pasteboard types after filtering:\n
					%{public}@\n
					"""
				os_log(.info, log: logger, debugString, pasteboardItem.types, filteredPasteboardItem.types)
			}

			pasteboard.clearContents()
			let wroteToPasteboard = pasteboard.writeObjects([filteredPasteboardItem])
			if wroteToPasteboard && Settings.debugEnabled {
				os_log(.info, log: logger, "%{public}@", plaintextString)
			} else {
				os_log(.info, log: logger, "Unable to write new pasteboard item to pasteboard")
			}
		}

		internalChangeCount = pasteboard.changeCount
	}

}

extension PasteboardMonitor: Enablable {
	func enable() {
		guard isEnabled == false else { return }
		isEnabled = true
		timer.resume()
	}

	func disable() {
		guard isEnabled == true else { return }
		isEnabled = false
		timer.suspend()
	}
}
