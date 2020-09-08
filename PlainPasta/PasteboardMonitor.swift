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
	private let timer = DispatchSource.makeTimerSource()

	init() {
		timer.schedule(deadline: .now(), repeating: .milliseconds(100))
		timer.setEventHandler { [weak self] in
			self?.checkPasteboard()
		}

		startTimer()
	}

	deinit {
		stopTimer()
	}

	/// The current state of the pasteboard monitor
	var isEnabled: Bool = true {
		didSet {
			if isEnabled {
				startTimer()
			} else {
				stopTimer()
			}
		}
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
	private func checkPasteboard() {
		if internalChangeCount != pasteboard.changeCount {

			guard let pasteboardItem = pasteboard.pasteboardItems?.first,
			      let plaintextString = pasteboardItem.string(forType: .string) else {
				internalChangeCount = pasteboard.changeCount
				return
			}

			let filteredPasteboardItem = pasteboardItem.plaintextifiedCopy
			pasteboard.clearContents()
			let wroteToPasteboard = pasteboard.writeObjects([filteredPasteboardItem])
			if wroteToPasteboard {
				internalChangeCount = pasteboard.changeCount
				logPlaintextStringToConsole(plaintextString)
			} else {
				print("Unable to write new pasteboard item to pasteboard")
			}
		}
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
