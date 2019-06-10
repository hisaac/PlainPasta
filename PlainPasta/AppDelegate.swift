// Created by Isaac Halvorson on 10/16/18

import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PasteboardMonitorDelegate {

	// MARK: - Initialization

	let pasteboardMonitor = PasteboardMonitor()

	let menuBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

	let enabledMenuItem = NSMenuItem(
		title: NSLocalizedString("Enabled", comment: "Title for Enabled menu item"),
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

		let aboutPlainPasta = NSMenuItem(
			title: NSLocalizedString("About Plain Pasta…", comment: "Title for About menu item"),
			action: #selector(openAboutPage),
			keyEquivalent: ""
		)

		let quit = NSMenuItem(
			title: NSLocalizedString("Quit", comment: "Title for Quit menu item"),
			action: #selector(NSApplication.terminate),
			keyEquivalent: "q"
		)

		let orderedMenuItems = [
			versionInfo,
			NSMenuItem.separator(),
			enabledMenuItem,
			NSMenuItem.separator(),
			aboutPlainPasta,
			quit
		]

		let menu = NSMenu()

		if #available(OSX 10.14, *) {
			menu.items = orderedMenuItems
		} else {
			_ = orderedMenuItems.map { item in
				menu.addItem(item)
			}
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
		let versionTitle = NSLocalizedString("Version", comment: "Version title for version information")
		let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""

		let buildTitle = NSLocalizedString("build", comment: "build title for version information")
		let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""

		return "\(versionTitle) \(versionNumber) (\(buildTitle) \(buildNumber))"
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
