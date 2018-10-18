// Created by Isaac Halvorson on 10/16/18

import Cocoa
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PasteboardMonitorDelegate {

	let pasteboardMonitor = PasteboardMonitor()
	let sparkleUpdater = SUUpdater(for: Bundle.main)

	let menuBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	let enabledMenuItem = NSMenuItem(title: "Enabled", action: #selector(toggleTimer), keyEquivalent: "")

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		pasteboardMonitor.delegate = self
		menuBarItem.button?.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
		enabledMenuItem.state = .on

		configureSparkle()
		constructMenu()
	}

	func configureSparkle() {
		sparkleUpdater?.feedURL = URL(string: "http://hisaac.net")!
		sparkleUpdater?.automaticallyChecksForUpdates = true
	}

	func constructMenu() {
		let versionInfo = NSMenuItem(title: appVersionTitle, action: nil, keyEquivalent: "")
		let checkForUpdates = NSMenuItem(title: "Check for Updates…", action: #selector(checkForAppUpdates), keyEquivalent: "")
		let about = NSMenuItem(title: "About…", action: #selector(openAboutPage), keyEquivalent: "")
		let quit = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate), keyEquivalent: "")

		let menu = NSMenu()
		menu.items = [
			versionInfo,
			checkForUpdates,
			NSMenuItem.separator(),
			enabledMenuItem,
			NSMenuItem.separator(),
			about,
			quit
		]

		menuBarItem.menu = menu
	}

	@objc func toggleTimer() {
		pasteboardMonitor.enabledState.toggle()
	}

	@objc func checkForAppUpdates() {
		sparkleUpdater?.checkForUpdates(nil)
	}

	@objc func openAboutPage() {
		NSWorkspace.shared.open(URL(string: "https://hisaac.net")!)
	}

	var appVersionTitle: String {
		let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
		let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
		return "Version \(versionNumber) (build \(buildNumber))"
	}
}
