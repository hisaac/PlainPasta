import AppKit
import os.log

class StatusItemController {

	weak var delegate: Enablable?
	private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	private (set) var isEnabled = false
	let logger: OSLog

	init(logger: OSLog) {
		self.logger = logger
		statusItem.button?.image = NSImage(named: "StatusBarButtonImage")
		statusItem.menu = buildMenu()
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

	private lazy var archiveInfoMenuItem: NSMenuItem = {
		let menuItem = NSMenuItem(
			title: "",
			action: #selector(openAboutPage),
			target: self
		)

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		let archiveWarningMessage = NSAttributedString(
			string: "⚠️ Plain Pasta is no longer being developed ⚠️\nClick here for more information",
			attributes: [
				.font: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize),
				.paragraphStyle: paragraphStyle
			]
		)
		menuItem.attributedTitle = archiveWarningMessage
		return menuItem
	}()

	/// Builds and returns a correctly ordered menu
	/// - Returns: A correctly ordered menu
	private func buildMenu() -> NSMenu {
		let menu = NSMenu()
		menu.items = [
			archiveInfoMenuItem,
			NSMenuItem(title: LocalizedStrings.appVersion, target: self, isEnabled: false),
			NSMenuItem.separator(),
			enabledMenuItem,
			NSMenuItem.separator(),
			debugMenuItem,
			NSMenuItem.separator(),
			NSMenuItem(title: LocalizedStrings.aboutPlainPastaMenuItemTitle, action: #selector(openAboutPage), target: self),
			NSMenuItem(title: LocalizedStrings.quitMenuItemTitle, action: #selector(NSApp.terminate), keyEquivalent: "q", target: NSApp)
		]
		return menu
	}

	// MARK: - Menu Item Actions

	/// Opens Plain Pasta's About page, currently the app's website
	@objc
	private func openAboutPage() {
		guard let url = URL(
			string: "https://github.com/hisaac/PlainPasta/blob/main/README.md#%EF%B8%8F-plain-pasta-is-no-longer-under-active-development-%EF%B8%8F"
		) else {
			return
		}
		NSWorkspace.shared.open(url)
	}

	/// Toggles debug mode for the app
	@objc
	private func toggleDebugMode() {
		Settings.debugEnabled.toggle()
		if Settings.debugEnabled {
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

// swiftlint:disable vertical_parameter_alignment
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
