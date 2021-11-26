import Foundation
import ProjectDescription

public extension SettingsDictionary {
    func appIconName(_ name: String) -> SettingsDictionary {
        merging(["ASSETCATALOG_COMPILER_APPICON_NAME": SettingValue(stringLiteral: name)])
    }

    func productName(_ name: String) -> SettingsDictionary {
        merging(["PRODUCT_NAME": SettingValue(stringLiteral: name)])
    }

    func productModuleName(_ name: String) -> SettingsDictionary {
        merging(["PRODUCT_MODULE_NAME": SettingValue(stringLiteral: name)])
    }
}
