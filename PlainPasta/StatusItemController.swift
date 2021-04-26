import AppKit
import Combine
import Defaults
import os.log

class StatusItemController: NSObject, NSMenuDelegate {

	weak var delegate: PreferencesWindowDelegate?
	private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	private lazy var menu = buildMenu()
	private let logger: OSLog

	init(logger: OSLog) {
		self.logger = logger
		super.init()
		statusItem.button?.image = NSImage(named: "StatusBarButtonImage")
		statusItem.button?.target = self
		statusItem.button?.action = #selector(_didClickStatusItem(_:))
		statusItem.button?.sendAction(on: [.leftMouseDown, .rightMouseUp])
		setupDefaultsObservers()
	}

	func setupDefaultsObservers() {
		Defaults.observe(.debugEnabled) { [weak self] change in
			if change.newValue {
				self?.debugMenuItem.state = .on
			} else {
				self?.debugMenuItem.state = .off
			}
		}.tieToLifetime(of: self)

		Defaults.observe(.filteringEnabled) { [weak self] change in
			if change.newValue {
				self?.enabledMenuItem.state = .on
			} else {
				self?.enabledMenuItem.state = .off
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

	/// Pulled from <https://github.com/hexedbits/StatusItemController/blob/main/Sources/StatusItemController.swift#L99-L106>
	@objc
	private func _didClickStatusItem(_ sender: NSStatusItem) {
		if NSApp.isCurrentEventRightClickUp {
			self.rightClickAction()
		} else {
			self.leftClickAction()
		}
	}

	private func rightClickAction() {
		toggleIsEnabled()
	}

	private func leftClickAction() {
		statusItem.menu = menu
		statusItem.button?.performClick(nil)
	}

	internal func menuDidClose(_ menu: NSMenu) {
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

extension NSApplication {

	/// Returns `true` if the application's current event is `.rightMouseUp` or equivalent.
	/// Returns `false` otherwise.
	public var isCurrentEventRightClickUp: Bool {
		if let current = self.currentEvent {
			return current.isRightClickUp
		}
		return false
	}
}

extension NSEvent {

	/// Returns `true` if the event is `.rightMouseUp` or equivalent.
	/// Returns `false` otherwise.
	public var isRightClickUp: Bool {
		let rightClick = (self.type == .rightMouseUp)
		let controlClick = self.modifierFlags.contains(.control)
		return rightClick || controlClick
	}
}
