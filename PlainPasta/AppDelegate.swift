import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PasteboardMonitorDelegate {

	// MARK: - Initialization

	let pasteboardMonitor = PasteboardMonitor(for: NSPasteboard.general)

	let menuBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

	let enabledMenuItem = NSMenuItem(
		title: LocalizedStrings.enabledMenuItem,
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
			title: LocalizedStrings.appVersion,
			action: nil,
			keyEquivalent: ""
		)

		let aboutPlainPasta = NSMenuItem(
			title: LocalizedStrings.aboutPlainPastaMenuItem,
			action: #selector(openAboutPage),
			keyEquivalent: ""
		)

		let quit = NSMenuItem(
			title: LocalizedStrings.quitMenuItem,
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
		pasteboardMonitor.isEnabled.toggle()
	}

	@objc func checkForAppUpdates() {
		guard let url = URL(string: "https://github.com/hisaac/PlainPasta/releases") else { return }
		NSWorkspace.shared.open(url)
	}

	@objc func openAboutPage() {
		guard let url = URL(string: "https://hisaac.github.io/PlainPasta/") else { return }
		NSWorkspace.shared.open(url)
	}
}
