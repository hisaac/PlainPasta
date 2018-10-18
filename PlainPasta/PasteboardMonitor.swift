// Created by Isaac Halvorson on 10/18/18

import Cocoa

protocol PasteboardMonitorDelegate: class {
	var enabledMenuItem: NSMenuItem { get }
}

class PasteboardMonitor {

	weak var delegate: PasteboardMonitorDelegate?

	private let pasteboard = NSPasteboard.general
	private var counter = 0
	private var timer: Timer?

	init() {
		startTimer()
	}

	var enabledState: Bool = true {
		didSet { enabledState ? startTimer() : stopTimer() }
	}

	private func startTimer() {
		delegate?.enabledMenuItem.state = .on
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
			self.checkPasteboard()
		}
	}

	private func stopTimer() {
		delegate?.enabledMenuItem.state = .off
		timer?.invalidate()
	}

	private func checkPasteboard() {
		if counter != pasteboard.changeCount {
			guard let string = pasteboard.string(forType: .string) else { return }

			pasteboard.clearContents()
			pasteboard.setString(string, forType: .string)
			counter = pasteboard.changeCount

			print(pasteboard.string(forType: .string)!)
		}
	}

}
