// Created by Isaac Halvorson on 2021-02-14

import Combine
import Defaults
import Preferences
import SwiftUI

extension Preferences.PaneIdentifier {
	static let general = Self("general")
}

/// The main view of "General" preference pane.
struct GeneralPreferencesView: View {

	@Default(.filteringEnabled) var filteringEnabled
	@Default(.showMenuItem) var showMenuItem
	@Default(.statusItemLeftClickBehavior) var statusItemLeftClickBehavior

	var body: some View {
		Preferences.Container(contentWidth: 480) {
			Preferences.Section(title: "Filtering:") {
				Toggle("Enable clipboard filtering", isOn: $filteringEnabled)
			}
			Preferences.Section(title: "Menu item:") {
				Toggle("Show menu item", isOn: $showMenuItem)
				Text("When the menu item is hidden, launching the app will bring up this preferences window")
					.preferenceDescription()
					.padding(.trailing, 10)
				Picker(selection: $statusItemLeftClickBehavior, label: EmptyView()) {
					Text("Clicking opens menu").tag(StatusItemLeftClickBehavior.openMenu)
					Text("Clicking toggles clipboard filtering").tag(StatusItemLeftClickBehavior.toggleFiltering)
				}
				.pickerStyle(RadioGroupPickerStyle())
				.disabled(showMenuItem)

				Text("Right-clicking will do the opposite of what's selected")
					.preferenceDescription()
			}
		}
	}
}

struct GeneralPreferencesView_Previews: PreviewProvider {
	static var previews: some View {
		GeneralPreferencesView()
	}
}
