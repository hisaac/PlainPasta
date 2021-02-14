// Created by Isaac Halvorson on 2021-02-14

import Defaults
import SwiftUI
import Preferences

extension Preferences.PaneIdentifier {
	static let general = Self("general")
}

/// The main view of "General" preference pane.
struct GeneralPreferencesView: View {

	@Default(.debugEnabled) var debugEnabled
	@Default(.filteringEnabled) var filteringEnabled
	private let contentWidth: Double = 450.0

	var body: some View {
		Preferences.Container(contentWidth: contentWidth) {
			Preferences.Section(title: "General:") {
				Toggle("Filtering enabled", isOn: $filteringEnabled)
				Toggle("Debug mode", isOn: $debugEnabled)
				Text("Prints extra logging information that can be useful for debugging issues").preferenceDescription()
			}
		}
	}
}

struct GeneralPreferencesView_Previews: PreviewProvider {
	static var previews: some View {
		GeneralPreferencesView()
	}
}
