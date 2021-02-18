//  Created by Isaac Halvorson on 2/17/21.

import Defaults
import Preferences
import SwiftUI

extension Preferences.PaneIdentifier {
	static let debugging = Self("debugging")
}

struct DebuggingPreferencesView: View {

	@Default(.debugEnabled) var debugEnabled

	var body: some View {
		Preferences.Container(contentWidth: 480) {
			Preferences.Section(title: "Debugging:") {
				Toggle("Debug logging", isOn: $debugEnabled)
				Text("Prints extra logging information that can be useful for debugging issues").preferenceDescription()
				Button("Reset to defaults") {
					Defaults.resetToDefaults()
				}
				Text("Resets all settings to their default state").preferenceDescription()
			}
		}
	}
}

struct DebuggingPreferencesView_Previews: PreviewProvider {
	static var previews: some View {
		DebuggingPreferencesView()
	}
}
