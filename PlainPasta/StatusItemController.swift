import AppKit
import Defaults
import os.log

class StatusItemController {

	typealias StatusItemControllerDelegate = Enablable & PreferencesWindowDelegate

	weak var delegate: StatusItemControllerDelegate?
	private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	private (set) var isEnabled = false
	private let logger: OSLog

	init(logger: OSLog) {
		self.logger = logger
		statusItem.button?.image = NSImage(named: "StatusBarButtonImage")
		statusItem.menu = buildMenu()
	}

	/// Builds and returns a correctly ordered menu
	/// - Returns: A correctly ordered menu
	private func buildMenu() -> NSMenu {
		let menu = NSMenu()
		menu.items = [
			NSMenuItem(
				title: LocalizedStrings.appVersion,
				target: self,
				isEnabled: false
			),
			NSMenuItem.separator(),
			enabledMenuItem,
			NSMenuItem.separator(),
			debugMenuItem,
			NSMenuItem.separator(),
			NSMenuItem(
				title: "Preferences…",
				action: #selector(openPreferencesWindow),
				keyEquivalent: ",",
				target: self
			),
			NSMenuItem(
				title: LocalizedStrings.aboutPlainPastaMenuItemTitle,
				action: #selector(openAboutPage),
				target: self
			),
			NSMenuItem(
				title: LocalizedStrings.quitMenuItemTitle,
				action: #selector(NSApp.terminate),
				keyEquivalent: "q",
				target: NSApp
			)
		]
		return menu
	}

	private lazy var enabledMenuItem: NSMenuItem = {
		return NSMenuItem(
			title: LocalizedStrings.enabledMenuItemTitle,
			action: #selector(toggleIsEnabled),
			target: self
		)
	}()

	private lazy var debugMenuItem: NSMenuItem = {
		return NSMenuItem(
			title: LocalizedStrings.debugMenuItemTitle,
			action: #selector(toggleDebugMode),
			target: self
		)
	}()

	// MARK: - Menu Item Actions

	@objc
	private func openPreferencesWindow() {
		delegate?.openPreferencesWindow()
	}

	/// Opens Plain Pasta's About page, currently the app's website
	@objc
	private func openAboutPage() {
		guard let url = URL(string: "https://hisaac.github.io/PlainPasta/") else { return }
		NSWorkspace.shared.open(url)
	}

	/// Toggles debug mode for the app
	@objc
	private func toggleDebugMode() {
		Defaults[.debugEnabled].toggle()
		if Defaults[.debugEnabled] {
			debugMenuItem.state = .on
		} else {
			debugMenuItem.state = .off
		}
	}

	/// Toggles the enabled state of the menu
	@objc
	private func toggleIsEnabled() {
		isEnabled ? disable() : enable()
	}
}

extension StatusItemController: Enablable {
	func enable() {
		guard isEnabled == false else { return }
		isEnabled = true
		enabledMenuItem.state = .on
		delegate?.enable()
	}

	func disable() {
		guard isEnabled == true else { return }
		isEnabled = false
		enabledMenuItem.state = .off
		delegate?.disable()
	}
}

extension NSMenuItem {
	convenience init(title: String,
					 action: Selector? = nil,
					 keyEquivalent: String = "",
					 target: AnyObject? = nil,
					 isEnabled: Bool = true) {
		self.init(title: title, action: action, keyEquivalent: keyEquivalent)
		self.target = target
		self.isEnabled = isEnabled
	}
}
