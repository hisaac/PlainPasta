import AppKit
import Combine
import Defaults
import os.log

class PasteboardMonitor {

	/// The pasteboard to monitor
	let pasteboard: NSPasteboard

	/// The change count used to compare to the given pasteboard's change count
	/// Initially set to the given pasteboard's change count
	private var internalChangeCount: Int

	private var timer: AnyCancellable?

	let logger: OSLog

	/// All of the types of pasteboard data to filter out when copying pasteboard data
	static let pasteboardTypeFilterList: [NSPasteboard.PasteboardType] = [
		.html,
		.rtf,
		.rtfd,
		.pdf, // This is for Microsoft Word compatibility
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

		setupDefaultsObservers()
	}

	func setupDefaultsObservers() {
		Defaults.observe(.filteringEnabled) { [weak self] change in
			if change.newValue {
				self?.startTimer()
			} else {
				self?.stopTimer()
			}
		}.tieToLifetime(of: self)
	}

	func startTimer() {
		timer = Timer.publish(every: 0.01, tolerance: 0.05, on: .main, in: .default)
			.autoconnect()
			.sink { [weak self] _ in
				guard let strongSelf = self else { return }
				strongSelf.checkPasteboard(strongSelf.pasteboard)
			}
	}

	func stopTimer() {
		timer?.cancel()
	}

	/// Checks the pasteboard for styled text contents, and strips the formatting if possible
	/// - Parameter pasteboard: The pasteboard to check and write to if necessary
	func checkPasteboard(_ pasteboard: NSPasteboard) {
		guard internalChangeCount != pasteboard.changeCount else { return }

		if let pasteboardItem = pasteboard.pasteboardItems?.first,
		   let plaintextString = pasteboardItem.string(forType: .string) {

			let filteredPasteboardItem = pasteboardItem.plaintextifiedCopy()

			if Defaults[.debugEnabled] {
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
			if wroteToPasteboard && Defaults[.debugEnabled] {
				os_log(.info, log: logger, "%{public}@", plaintextString)
			} else {
				os_log(.info, log: logger, "Unable to write new pasteboard item to pasteboard")
			}
		}

		internalChangeCount = pasteboard.changeCount
	}

}
