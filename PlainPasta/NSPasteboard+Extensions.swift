import AppKit

extension NSPasteboardItem {

	open override var debugDescription: String {
		var debugDescription = "Pasteboard Content:\n"
		for type in types {
			debugDescription += "\n\(type): \(string(forType: type) ?? "Cannot be represented as a String")"
		}
		return "\(debugDescription)\n"
	}

	/// A copy of the pasteboard item with all styled text removed
	var plaintextifiedCopy: NSPasteboardItem {

		/// All of the types of pasteboard data to filter out when copying pasteboard data
		let pasteboardTypeFilterList: [NSPasteboard.PasteboardType] = [
			.html,
			.rtf,
			.rtfd,
			NSPasteboard.PasteboardType("public.url-name"),
			NSPasteboard.PasteboardType("CorePasteboardFlavorType 0x75726C6E"),
			NSPasteboard.PasteboardType("WebURLsWithTitlesPboardType")
		]

		let newPasteboardItem = NSPasteboardItem()
		for type in types {
			// Filter out any dynamic pasteboard types, and any types in our "avoid" list
			guard type.rawValue.hasPrefix("dyn.") == false,
				pasteboardTypeFilterList.contains(type) == false,
				let data = data(forType: type) else {
					continue
			}

			newPasteboardItem.setData(data, forType: type)
		}

		return newPasteboardItem
	}
}
