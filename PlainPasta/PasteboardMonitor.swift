import AppKit
import os.log

protocol PasteboardMonitorDelegate: class {
	var enabledMenuItem: NSMenuItem { get }
}

class PasteboardMonitor {

	/// The pasteboard to monitor
	let pasteboard: NSPasteboard

	/// The change count used to compare to the given pasteboard's change count
	/// Initially set to the given pasteboard's change count
	private var internalChangeCount: Int

	weak var delegate: PasteboardMonitorDelegate?
	private let timer = DispatchSource.makeTimerSource()

	init(for pasteboard: NSPasteboard) {
		self.pasteboard = pasteboard
		self.internalChangeCount = self.pasteboard.changeCount

		timer.schedule(deadline: .now(), repeating: .milliseconds(100))
		timer.setEventHandler { [weak self] in
			if let pasteboard = self?.pasteboard {
				self?.checkPasteboard(pasteboard)
			}
		}

		startTimer()
	}

	deinit {
		stopTimer()
	}

	/// The current state of the pasteboard monitor
	var isEnabled: Bool = true {
		didSet { isEnabled ? startTimer() : stopTimer() }
	}

	/// Starts monitoring the pasteboard, and sets the menu item's state to enabled
	private func startTimer() {
		delegate?.enabledMenuItem.state = .on
		timer.resume()
	}

	/// Stops monitoring the pasteboard, and sets the menu item's state to disabled
	private func stopTimer() {
		delegate?.enabledMenuItem.state = .off
		timer.cancel()
	}

	/// Checks the pasteboard for styled text contents, and strips the formatting if possible
	func checkPasteboard(_ pasteboard: NSPasteboard) {
		guard internalChangeCount != pasteboard.changeCount else { return }

		if let pasteboardItem = pasteboard.pasteboardItems?.first,
		   let plaintextString = pasteboardItem.string(forType: .string) {

			let filteredPasteboardItem = pasteboardItem.plaintextifiedCopy
			pasteboard.clearContents()
			let wroteToPasteboard = pasteboard.writeObjects([filteredPasteboardItem])
			if wroteToPasteboard {
				logPlaintextStringToConsole(plaintextString)
			} else {
				print("Unable to write new pasteboard item to pasteboard")
			}
		}

		internalChangeCount = pasteboard.changeCount
	}

	private func logPlaintextStringToConsole(_ plaintextString: String) {
		let debugFormatString: String = "plaintext pasteboard content: %@"
		let debugFormatStaticString: StaticString = "plaintext pasteboard content: %@"
		if #available(OSX 10.14, *) {
			os_log(.info, debugFormatStaticString, plaintextString)
		} else if #available(OSX 10.12, *) {
			os_log(debugFormatStaticString, log: .default, type: .info, plaintextString)
		} else {
			NSLog(debugFormatString, plaintextString)
		}
	}

}
