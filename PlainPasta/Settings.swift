// Created by Isaac Halvorson on 10/29/20

import Foundation

struct Settings {
	@UserDefaultsBacked(key: "debugMode", defaultValue: false)
	static var debugMode: Bool
}
