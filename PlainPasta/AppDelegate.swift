// Created by Isaac Halvorson on 10/16/18

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PasteboardMonitorDelegate {

	// MARK: - Initialization

	let pasteboardMonitor = PasteboardMonitor()

	let menuBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

	let enabledMenuItem = NSMenuItem(
		title: L10n.enabled,
		action: #selector(toggleTimer),
		keyEquivalent: ""
	)

	// MARK: - AppDelegate Methods

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		pasteboardMonitor.delegate = self
		menuBarItem.button?.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
		enabledMenuItem.state = .on
		constructMenu()
	}

	// MARK: - Menu Configuration

	func constructMenu() {

		let versionInfo = NSMenuItem(
			title: appVersionTitle,
			action: nil,
			keyEquivalent: ""
		)

		let checkForUpdates = NSMenuItem(
			title: L10n.checkForUpdates,
			action: #selector(checkForAppUpdates),
			keyEquivalent: ""
		)

		let aboutPlainPasta = NSMenuItem(
			title: L10n.aboutPlainPasta,
			action: #selector(openAboutPage),
			keyEquivalent: ""
		)

		let quit = NSMenuItem(
			title: L10n.quit,
			action: #selector(NSApplication.terminate),
			keyEquivalent: "q"
		)

		let orderedMenuItems = [
			versionInfo,
			checkForUpdates,
			NSMenuItem.separator(),
			enabledMenuItem,
			NSMenuItem.separator(),
			aboutPlainPasta,
			quit
		]

		let menu = NSMenu()

		_ = orderedMenuItems.map { item in
			menu.addItem(item)
		}

		menuBarItem.menu = menu
	}

	// MARK: - Menu Item Actions

	@objc func toggleTimer() {
		pasteboardMonitor.enabledState.toggle()
	}

	@objc func checkForAppUpdates() {
		NSWorkspace.shared.open(URL(staticString: "https://github.com/hisaac/PlainPasta/releases"))
	}

	@objc func openAboutPage() {
		NSWorkspace.shared.open(URL(staticString: "https://hisaac.github.io/PlainPasta/"))
	}

	var appVersionTitle: String {
		let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
		let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
		return "\(L10n.version) \(versionNumber) (\(L10n.build) \(buildNumber))"
	}
}

extension URL {

	/// Allows for creation of a `URL` with a `StaticString`
	/// (via [Swift by Sundell](https://www.swiftbysundell.com/posts/constructing-urls-in-swift))
	///
	init(staticString: StaticString) {
		guard let url = URL(string: "\(staticString)") else {
			preconditionFailure("Invalid static URL string: \(staticString)")
		}

		self = url
	}
}
