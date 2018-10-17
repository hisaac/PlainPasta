// Created by Isaac Halvorson on 10/16/18

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

	let pasteboard = NSPasteboard.general
	var timer: Timer?
	var counter = 0

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		statusItem.button?.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
		constructMenu()
		startTimer()
	}

	func constructMenu() {
		let menu = NSMenu()

		let enable = NSMenuItem(title: "Enable", action: nil, keyEquivalent: "")
		let about = NSMenuItem(title: "About Plain Pasta", action: nil, keyEquivalent: "")
		let separator = NSMenuItem.separator()
		let preferences = NSMenuItem(title: "Preferences…", action: nil, keyEquivalent: "")
		let quit = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate), keyEquivalent: "")

		menu.items = [
			enable,
			separator,
			preferences,
			about,
			quit
		]

		statusItem.menu = menu
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
