import AppKit
import Combine
import Defaults
import KeyboardShortcuts
import os.log
import PasteboardPublisher

class PasteboardMonitor {

	/// The pasteboard to monitor
	let pasteboard: NSPasteboard

	var pasteboardPublisher: AnyCancellable?

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

		setupDefaultsObservers()
	}

	func setupDefaultsObservers() {
		Defaults.observe(.filteringEnabled) { [weak self] change in
			if change.newValue {
				self?.startMonitoring()
			} else {
				self?.stopMonitoring()
			}
		}.tieToLifetime(of: self)

		KeyboardShortcuts.onKeyUp(for: .toggleClipboardFiltering) {
			Defaults[.filteringEnabled].toggle()
		}

		#warning("TODO: Implement plaintextify shortcut")
		KeyboardShortcuts.onKeyDown(for: .plaintextifyClipboard) {
			print("plaintextify pressed")
		}

		#warning("TODO: Implement undo plaintextification shortcut")
		KeyboardShortcuts.onKeyDown(for: .undoPlaintextification) {
			print("undo plaintextification pressed")
		}
	}

	func startMonitoring() {
		pasteboardPublisher = pasteboard.publisher()
			.sink { [weak self] pasteboardItems in
				self?.filter(pasteboardItems: pasteboardItems)
			}
	}

	func stopMonitoring() {
		pasteboardPublisher?.cancel()
	}

	/// Filters styling from the contents of the pasteboard, and places the filtered contents back onto the pasteboard
	/// - Parameter pasteboardItems: The items to filter
	private func filter(pasteboardItems: [NSPasteboardItem]) {
		var filteredPasteboardItems: [NSPasteboardItem] = []

		for item in pasteboardItems {
			// If it's impossible to convert this pasteboard item to a string we'll ignore it
			guard item.string(forType: .string) != nil else { continue }

			let filteredItem = item.plaintextifiedCopy()

			if Defaults[.debugEnabled] {
				// Print out pasteboard types for help in debugging
				let debugString: StaticString = """
					Pasteboard types before filtering: %{public}@
					Pasteboard types after filtering: %{public}@
					"""
				os_log(.info, log: logger, debugString, item.types, filteredItem.types)
			}

			filteredPasteboardItems.append(filteredItem)
		}

		guard filteredPasteboardItems.isEmpty == false else { return }
		pasteboard.clearContents()
		let successfullyWroteToPasteboard = pasteboard.writeObjects(filteredPasteboardItems)

		if successfullyWroteToPasteboard && Defaults[.debugEnabled] {
			for item in filteredPasteboardItems {
				guard let plaintextString = item.string(forType: .string) else { continue }
				os_log(.debug, log: logger, "%{public}@", plaintextString)
			}
		} else {
			os_log(.info, log: logger, "Unable to write new pasteboard item to pasteboard")
		}
	}

}
