import Foundation
import ProjectDescription

public extension SettingsDictionary {
    func appIconName(_ name: String) -> SettingsDictionary {
        merging([
            "ASSETCATALOG_COMPILER_APPICON_NAME": .string(name)
        ])
    }
}
