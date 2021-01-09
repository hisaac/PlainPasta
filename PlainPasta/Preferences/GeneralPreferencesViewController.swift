import AppKit
import Preferences

extension Preferences.PaneIdentifier {
	static let general = Self("general")
}

class GeneralPreferencesViewController: NSViewController, PreferencePane {

	var preferencePaneIdentifier = Preferences.PaneIdentifier.general
	var preferencePaneTitle = "General"
	var toolbarItemIcon: NSImage?

	override var nibName: NSNib.Name? { "GeneralPreferencesViewController" }

	override func viewDidLoad() {
		super.viewDidLoad()

		preferredContentSize = NSSize(width: 760, height: 320)

		if #available(OSX 11.0, *) {
			toolbarItemIcon = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General preferences")
		}
	}

}
