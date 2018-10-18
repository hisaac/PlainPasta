// Created by Isaac Halvorson on 10/18/18

import Cocoa

protocol PasteboardMonitorDelegate: class {
	var enabledMenuItem: NSMenuItem { get }
}

class PasteboardMonitor {

	weak var delegate: PasteboardMonitorDelegate?

	let pasteboard = NSPasteboard.general
	var counter = 0
	var timer: Timer?

	init() {
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
			self.checkPasteboard()
		}
	}

	var enabledState: Bool = true {
		didSet {
			delegate?.enabledMenuItem.state = enabledState ? .on : .off
			enabledState ? timer?.fire() : timer?.invalidate()
		}
	}

	func checkPasteboard() {
		if counter != pasteboard.changeCount {
			guard let string = pasteboard.string(forType: .string) else { return }

			pasteboard.clearContents()
			pasteboard.setString(string, forType: .string)
			counter = pasteboard.changeCount

			print(pasteboard.string(forType: .string)!)
		}
	}

}
