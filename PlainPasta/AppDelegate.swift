// Created by Isaac Halvorson on 10/16/18

import Cocoa
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PasteboardMonitorDelegate {

	// MARK: - Initialization

	let pasteboardMonitor = PasteboardMonitor()
	let sparkleUpdater = SUUpdater(for: Bundle.main)

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

		configureSparkle()
		constructMenu()
	}

	// MARK: - Sparkle Configuration

	func configureSparkle() {
		sparkleUpdater?.feedURL = URL(staticString: "http://hisaac.net")
		sparkleUpdater?.automaticallyChecksForUpdates = true
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

		let about = NSMenuItem(
			title: L10n.about,
			action: #selector(openAboutPage),
			keyEquivalent: ""
		)

		let quit = NSMenuItem(
			title: L10n.quit,
			action: #selector(NSApplication.terminate),
			keyEquivalent: ""
		)

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

	// MARK: - Menu Item Actions

	@objc func toggleTimer() {
		pasteboardMonitor.enabledState.toggle()
	}

	@objc func checkForAppUpdates() {
		sparkleUpdater?.checkForUpdates(nil)
	}

	@objc func openAboutPage() {
		NSWorkspace.shared.open(URL(staticString: "https://hisaac.net"))
	}

	var appVersionTitle: String {
		let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
		let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
		let localizedVersionWord = L10n.version
		let localizedBundleWord = L10n.bundle
		return "\(localizedVersionWord) \(versionNumber) (\(localizedBundleWord) \(buildNumber))"
	}
}

extension URL {

	/// via: [John Sundell](https://www.swiftbysundell.com/posts/constructing-urls-in-swift)
	init(staticString: StaticString) {
		guard let url = URL(string: "\(staticString)") else {
			preconditionFailure("Invalid static URL string: \(staticString)")
		}

		self = url
	}
}
