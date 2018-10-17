// Created by Isaac Halvorson on 10/16/18

import Cocoa
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

	let pasteboard = NSPasteboard.general
	var timer: Timer?
	var counter = 0

	var sparkleUpdater: SUUpdater?

	let enabledMenuItem = NSMenuItem(title: "Enabled", action: #selector(toggleTimer), keyEquivalent: "")

	var appVersionTitle: String {
		let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
		let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
		return "Version \(versionNumber) (build \(buildNumber))"
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		statusItem.button?.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
		sparkleUpdater = SUUpdater(for: Bundle.main)
		constructMenu()
	}

	func configureSparkle() {
		guard let sparkleUpdater = sparkleUpdater else { return }

		sparkleUpdater.feedURL = URL(string: "http://hisaac.net")!
		sparkleUpdater.automaticallyChecksForUpdates = true
	}

	func constructMenu() {
		let menu = NSMenu()

		let versionInfo = NSMenuItem(title: appVersionTitle, action: nil, keyEquivalent: "")
		let checkForUpdates = NSMenuItem(title: "Check for Updates…", action: #selector(checkForAppUpdates), keyEquivalent: "")
		let about = NSMenuItem(title: "About…", action: #selector(openAboutPage), keyEquivalent: "")
		let quit = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate), keyEquivalent: "")

		setEnabledState()

		menu.items = [
			versionInfo,
			checkForUpdates,
			NSMenuItem.separator(),
			enabledMenuItem,
			NSMenuItem.separator(),
			about,
			quit
		]

		statusItem.menu = menu
	}

	@objc func checkForAppUpdates() {
		sparkleUpdater?.checkForUpdates(nil)
	}

	func setEnabledState() {
		if let timer = timer, timer.isValid {
			enabledMenuItem.state = .on
		} else {
			enabledMenuItem.state = .off
		}
	}

	@objc func openAboutPage() {
		NSWorkspace.shared.open(URL(string: "https://hisaac.net")!)
	}

	func startTimer() {
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
			self.checkPasteboard()
		}
	}

	@objc func toggleTimer() {
		if let timer = timer, timer.isValid {
			timer.invalidate()
			UserDefaults.standard.set(false, forKey: "enabled")
		} else {
			startTimer()
			UserDefaults.standard.set(true, forKey: "enabled")
		}

		setEnabledState()
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
