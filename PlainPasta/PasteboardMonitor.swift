import AppKit
import os.log

class PasteboardMonitor {

	/// The pasteboard to monitor
	let pasteboard: NSPasteboard

	/// The change count used to compare to the given pasteboard's change count
	/// Initially set to the given pasteboard's change count
	private var internalChangeCount: Int

	private var timer: Timer?

	private (set) var isEnabled = false

	init(for pasteboard: NSPasteboard) {
		self.pasteboard = pasteboard
		self.internalChangeCount = pasteboard.changeCount
	}

	/// Checks the pasteboard for styled text contents, and strips the formatting if possible
	/// - Parameter pasteboard: The pasteboard to check and write to if necessary
	func checkPasteboard(_ pasteboard: NSPasteboard) {
		guard internalChangeCount != pasteboard.changeCount else { return }

		if let pasteboardItem = pasteboard.pasteboardItems?.first,
		   let plaintextString = pasteboardItem.string(forType: .string) {

			let filteredPasteboardItem = pasteboardItem.plaintextifiedCopy
			pasteboard.clearContents()
			let wroteToPasteboard = pasteboard.writeObjects([filteredPasteboardItem])
			if wroteToPasteboard {
				os_log("%@", type: .debug, plaintextString)
			} else {
				os_log("%@", type: .default, "Unable to write new pasteboard item to pasteboard")
			}
		}

		internalChangeCount = pasteboard.changeCount
	}

}

extension PasteboardMonitor: Enablable {
	func enable() {
		guard isEnabled == false else { return }
		isEnabled = true

		timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { [weak self] _ in
			guard let pasteboard = self?.pasteboard else { return }
			self?.checkPasteboard(pasteboard)
		}
	}

	func disable() {
		guard isEnabled == true else { return }
		isEnabled = false
		timer?.invalidate()
	}
}
