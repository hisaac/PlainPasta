// Created by Isaac Halvorson on 10/16/18

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var timer: Timer?
	let pasteboard = NSPasteboard.general
	var counter = 0

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		startTimer()
	}

	func startTimer() {
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
			self.checkPasteboard()
		}
	}

	func checkPasteboard() {
		if counter != pasteboard.changeCount {
			counter = pasteboard.changeCount

			if let string = pasteboard.string(forType: .string) {
				print("string ===", string)
			} else if let html = pasteboard.string(forType: .html) {
				print("html ===", html)
			} else if let rtf = pasteboard.string(forType: .rtf) {
				print("rtf ===", rtf)
			} else if let rtfd = pasteboard.string(forType: .rtfd) {
				print("rtfd ===", rtfd)
			} else if let tabularText = pasteboard.string(forType: .tabularText) {
				print("tabularText ===", tabularText)
			} else if let multipleTextSelection = pasteboard.string(forType: .multipleTextSelection) {
				print("multipleTextSelection ===", multipleTextSelection)
			}
		}
	}
}
