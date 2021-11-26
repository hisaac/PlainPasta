import AppKit
import Combine
import Defaults
import os.log

final class StatusItemController: NSObject {

	weak var delegate: PreferencesWindowDelegate?
	private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	private lazy var menu = buildMenu()
	private let logger: OSLog

	init(logger: OSLog) {
		self.logger = logger
		super.init()
		setupStatusItem()
		setupUserDefaultsObservers()
	}

	private func setupStatusItem() {
		statusItem.button?.image = NSImage(named: "StatusBarButtonImage")
		statusItem.button?.target = self
		statusItem.button?.action = #selector(didClickStatusItem(_:))
		statusItem.button?.sendAction(on: [.leftMouseDown, .rightMouseUp])
	}

	private func setupUserDefaultsObservers() {
		Defaults.observe(.debugEnabled) { [weak self] change in
			guard let self = self else { return }

			if change.newValue == true {
				self.debugMenuItem.state = .on
			} else {
				self.debugMenuItem.state = .off
			}
		}.tieToLifetime(of: self)

		Defaults.observe(.filteringEnabled) { [weak self] change in
			guard let self = self else { return }

			if change.newValue == true {
				self.enabledMenuItem.state = .on
				self.statusItem.button?.appearsDisabled = false
			} else {
				self.enabledMenuItem.state = .off
				self.statusItem.button?.appearsDisabled = true
			}
		}.tieToLifetime(of: self)
	}

	/// Builds and returns a correctly ordered menu
	/// - Returns: A correctly ordered menu
	private func buildMenu() -> NSMenu {
		let menu = NSMenu()
		menu.delegate = self
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
	}

	/// Toggles the enabled state of the menu
	@objc
	private func toggleIsEnabled() {
		Defaults[.filteringEnabled].toggle()
	}

	@objc
	private func didClickStatusItem(_ sender: NSStatusItem) {
		if isCurrentEventRightClickUp() {
			rightClickAction()
		} else {
			leftClickAction()
		}
	}

	private func isCurrentEventRightClickUp() -> Bool {
		guard let currentEvent = NSApp.currentEvent else { return false }
		let isRightClick = currentEvent.type == .rightMouseUp
		let isControlClick = currentEvent.modifierFlags.contains(.control)
		return isRightClick || isControlClick
	}

	private func rightClickAction() {
		toggleIsEnabled()
	}

	private func leftClickAction() {
		statusItem.menu = menu
		statusItem.button?.performClick(nil)
	}
}

extension StatusItemController: NSMenuDelegate {
	internal func menuDidClose(_ menu: NSMenu) {
		// In order to handle a right-click event on the status item,
		// we need to set the status item's menu to `nil`. Otherwise
		// a right-click will perform the same action as a left-click.
		statusItem.menu = nil
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
