//  Created by Isaac Halvorson on 2/17/21.

import KeyboardShortcuts
import Preferences
import SwiftUI

extension Preferences.PaneIdentifier {
	static let keyboardShortcuts = Self("keyboardShortcuts")
}

extension KeyboardShortcuts.Name {
	static let toggleClipboardFiltering = Self("toggleClipboardFiltering")
	static let plaintextifyClipboard = Self("plaintextifyClipboard")
	static let undoPlaintextification = Self("undoPlaintextification")
}

struct KeyboardShortcutsPreferencesView: View {
	var body: some View {
		Preferences.Container(contentWidth: 480) {
			Preferences.Section(title: "Toggle clipboard filtering:") {
				KeyboardShortcuts.Recorder(for: .toggleClipboardFiltering)
			}
			Preferences.Section(title: "Plaintextify clipboard contents:") {
				KeyboardShortcuts.Recorder(for: .plaintextifyClipboard)
				Text("Use this keyboard shortcut to manually strip styling from your clipboard when filtering is disabled").preferenceDescription()
			}
			Preferences.Section(title: "Undo plaintextification:") {
				KeyboardShortcuts.Recorder(for: .undoPlaintextification)
				Text("Use this keyboard shortcut to revert the current clipboard contents to their original non-filtered contents").preferenceDescription()
			}
		}
	}
}

struct KeyboardShortcutsPreferencesView_Previews: PreviewProvider {
	static var previews: some View {
		KeyboardShortcutsPreferencesView()
	}
}
