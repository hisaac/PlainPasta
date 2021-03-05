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
	func plaintextifiedCopy(filteredTypes: [NSPasteboard.PasteboardType] = PasteboardMonitor.pasteboardTypeFilterList) -> NSPasteboardItem {
		let newPasteboardItem = NSPasteboardItem()
		for type in types {
			// Filter out any dynamic pasteboard types, and any types in our "avoid" list
			guard type.rawValue.hasPrefix("dyn.") == false,
				  filteredTypes.contains(type) == false,
				  let data = data(forType: type) else {
					continue
			}

			newPasteboardItem.setData(data, forType: type)
		}

		return newPasteboardItem
	}
}
