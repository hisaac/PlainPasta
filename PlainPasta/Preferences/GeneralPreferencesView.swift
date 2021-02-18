// Created by Isaac Halvorson on 2021-02-14

import Combine
import Defaults
import SwiftUI
import Preferences

extension Preferences.PaneIdentifier {
	static let general = Self("general")
}

/// The main view of "General" preference pane.
struct GeneralPreferencesView: View {

	@Default(.filteringEnabled) var filteringEnabled
	@Default(.hideMenuItem) var hideMenuItem
	@Default(.leftClickBehavior) var leftClickBehavior

	var body: some View {
		Preferences.Container(contentWidth: 480) {
			Preferences.Section(title: "Filtering:") {
				Toggle("Enable clipboard filtering", isOn: $filteringEnabled)
			}
			Preferences.Section(title: "Menu item:") {
				Toggle("Hide menu item", isOn: $hideMenuItem)
				Text("When the menu item is hidden, opening the app brings up this preferences window")
					.preferenceDescription()
					.padding(.trailing, 10)
				Picker(selection: $leftClickBehavior, label: EmptyView()) {
					Text("Clicking opens menu").tag(LeftClickBehavior.openMenu)
					Text("Clicking toggles clipboard filtering").tag(LeftClickBehavior.toggleFiltering)
				}
				.pickerStyle(RadioGroupPickerStyle())
				.disabled(hideMenuItem)

				Text("Right-clicking will do the opposite of what's selected").preferenceDescription()
			}
		}
	}
}

struct GeneralPreferencesView_Previews: PreviewProvider {
	static var previews: some View {
		GeneralPreferencesView()
	}
}
