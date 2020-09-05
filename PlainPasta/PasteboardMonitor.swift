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

			// Check to see if the item on the pasteboard is a file or directory, and exit if it is
			guard pasteboard.availableType(from: [.fileName]) == nil else { return }

			// Check to see if there is styled text on the pasteboard, and exit if not
			guard pasteboard.availableType(from: [.rtf, .rtfd]) != nil else { return }

			guard let pasteboardItem = pasteboard.pasteboardItems?.first else { return }
			guard let plaintextString = pasteboardItem.string(forType: .string) else { return }

			let newPasteboardItem = NSPasteboardItem()
			for type in pasteboardItem.types {
				if type == .rtf || type == .rtfd {
					newPasteboardItem.setString(plaintextString, forType: type)
				} else {
					guard let data = pasteboardItem.data(forType: type) else { continue }
					newPasteboardItem.setData(data, forType: type)
				}
			}

			pasteboard.clearContents()
			let wroteToPasteboard = pasteboard.writeObjects([newPasteboardItem])
			if wroteToPasteboard {
				internalChangeCount = pasteboard.changeCount
				logPlaintextStringToConsole(plaintextString)
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
