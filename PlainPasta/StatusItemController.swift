import AppKit

class StatusItemController {

	weak var delegate: Enablable?
	private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	private (set) var isEnabled = false

	init() {
		statusItem.button?.image = NSImage(named: "StatusBarButtonImage")
		statusItem.menu = buildMenu()
	}

	private lazy var enabledMenuItem: NSMenuItem = {
		return NSMenuItem(
			title: LocalizedStrings.enabledMenuItem,
			action: #selector(toggleIsEnabled),
			target: self
		)
	}()

	/// Builds and returns a correctly ordered menu
	/// - Returns: A correctly ordered menu
	private func buildMenu() -> NSMenu {
		let menuItems: [NSMenuItem] = [
			NSMenuItem(title: LocalizedStrings.appVersion, target: self, isEnabled: false),
			NSMenuItem.separator(),
			enabledMenuItem,
			NSMenuItem.separator(),
			NSMenuItem(title: LocalizedStrings.aboutPlainPastaMenuItem, action: #selector(openAboutPage), target: self),
			NSMenuItem(title: LocalizedStrings.quitMenuItem, action: #selector(NSApp.terminate), keyEquivalent: "q", target: NSApp)
		]

		let menu = NSMenu()
		for item in menuItems {
			menu.addItem(item)
		}
		return menu
	}

	// MARK: - Menu Item Actions

	/// Opens Plain Pasta's About page, currently the app's website
	@objc
	private func openAboutPage() {
		guard let url = URL(string: "https://hisaac.github.io/PlainPasta/") else { return }
		NSWorkspace.shared.open(url)
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
