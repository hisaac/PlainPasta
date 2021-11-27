import Foundation
import ProjectDescription

public extension SettingsDictionary {
    func appTargetSettings() -> SettingsDictionary {
        merging([
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            "PRODUCT_NAME": "Plain Pasta",
            "PRODUCT_MODULE_NAME": "PlainPasta"
        ])
    }

    func testTargetSettings() -> SettingsDictionary {
        merging([
            "TEST_TARGET_NAME": "Plain Pasta",
            "TEST_HOST": "$(BUILT_PRODUCTS_DIR)/Plain Pasta.app/Contents/MacOS/Plain Pasta"
        ])
    }
}
