// Created by Isaac Halvorson on 10/16/18

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	let pasteboard = NSPasteboard.general
	var timer: Timer?
	var counter = 0

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		startTimer()
	}

	func startTimer() {
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
			self.checkPasteboard()
		}
	}

	func stopTimer() {
		timer?.invalidate()
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
