# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!-- ## [Unreleased] -->

## [1.2.1] - 2020-12-23

### Fixed

- Fix debug logging so it shows up in the Console.app as expected

## [1.2.0] - 2020-12-23

### Highlights

- Universal build compatible with Apple Silicon! 🎉
- Adds a Debug menu item, which will print out the pasteboard types before and after filtering

### Added

- Adds a Debug menu item, which will print out the pasteboard types before and after filtering
- Adds the `public.utf16-external-plain-text` pasteboard type to the filter list to address styling of text being copied from within Xcode's console not being filtered
- Adds a new `Settings` struct, backed by `UserDefaults`, to be used for user settings

### Changed

- Universal build compatible with Apple Silicon! 🎉
- Reverts back to using `DispatchSourceTimer` to reduce memory/CPU footprint
- Convert project configuration to `xcconfig` files using [BuildSettingExtractor](https://buildsettingextractor.com)
- Adds [`VerifyNoBS`](https://github.com/olofhellman/VerifyNoBS) build script to verify there are no build settings in the `.xcodeproj` file
- Convert tests to use a Test Plan, and add a Thread Sanitizer and Address Sanitizer test plan configuration

## [1.1.6] - 2020-09-20

### Fixed

- Adds the `com.apple.WebKit.custom-pasteboard-data` pasteboard type to the filter list, to fix an issue with copying and pasting styled text to and from Atlassian's [Confluence](https://confluence.atlassian.com/alldoc/atlassian-documentation-32243719.html). Thanks to Harry Strand for the bug report!

### Changed

- Update xcodeproj format to "Xcode 12.0-compatible"
- Extract `pasteboardTypeFIlterList` into a variable within `PasteboardMonitor`, and make `plaintextifiedCopy` into a method with the filtered types as an argument
	- This is to make unit testing and future debugging easier

### Added

- Added some tests for the new `plaintextifiedCopy` method

## [1.1.5] - 2020-09-15

### Fixed

- Adds the `com.apple.webarchive` pasteboard type to the filter list, to fix an issue specifically with copying styled text from a web page, and pasting into a Gmail compose field. Thanks to Christopher Stout for the bug report!

### Changed

- Significant refactor of code structure to make future updates easier.
- Changed build numbering scheme to comply with App Store requirements.

## [1.1.4] - 2020-09-12

This is the first version released to the Mac App Store! Going forward, the MAS will be the preferred place to download the app.

https://apps.apple.com/us/app/plain-pasta/id1467796430

### Added

- Adds `.html` to the pasteboard types to filter.
- Adds a test for the `.html` filter.

### Changed

- Links on web page now point to the App Store version.

## [1.1.3] - 2020-09-10

### Fixed

- Fixes a crash that would happen if you enabled, disabled, then re-enabled filtering again.
	- This was caused by trying to re-enable a cancelled GCD timer. The fix was to "suspend" the timer rather than cancel it.

### Added

- Adds a unit test target and some unit tests to verify the pasteboard filtering functionality

## [1.1.2] - 2020-09-08

### Fixed

- Fixes a regression where the pasteboard would sometimes get incorrectly overwritten to empty

### Changed

- Improved console debugging of `NSPasteboardItem` objects
- Changed changelog layout slightly to highlight fixes before changes

## [1.1.1] - 2020-09-07

### Fixed

- Fixed a bug in handling named URLs on the pasteboard by adding a few more types to the type filtered list:
- `public.url-name`
- `CorePasteboardFlavorType 0x75726C6E`
- `WebURLsWithTitlesPboardType`
- Dynamic pasteboard types, which are any type beginning with `dyn.` - I learned of these via [this blog post](https://camdez.com/blog/2010/07/21/nspasteboard-and-dynamic-utis/) by [@camdez](https://github.com/camdez)

### Changed

- Extracted pasteboard filtering to its own method as an extension on `NSPasteboardItem`

## [1.1.0] - 2020-09-07

### Fixed

- Fixed a bug that would cause images on the pasteboard to be removed ([reported](https://github.com/hisaac/PlainPasta/issues/3) by [@foigus](https://github.com/foigus). Thanks!)

### Changed

- Move to using GCD instead of `Timer` for repeat polling of the pasteboard. This provides a small increase in performance.
- Update entitlements file to allow for automatic creation of App ID in App Store Connect
- Remove "Check for Updates…" menu item, as this will now be done through the App Store
- Enable App Sandboxing for Mac App Store
- Enable hardened runtime
- Move Localizable.strings into Swift file

## [1.0.0] - 2018-11-04

Initial release! 🎉

[Unreleased]: https://github.com/hisaac/PlainPasta/compare/master...development
[1.0.0]: https://github.com/hisaac/PlainPasta/compare/3f3479bf1b417790735aa6cfb8850eb73fe74a07...1.0.0
[1.1.0]: https://github.com/hisaac/PlainPasta/compare/1.0.0...1.1.0
[1.1.1]: https://github.com/hisaac/PlainPasta/compare/1.1.0...1.1.1
[1.1.2]: https://github.com/hisaac/PlainPasta/compare/1.1.1...1.1.2
[1.1.3]: https://github.com/hisaac/PlainPasta/compare/1.1.2...1.1.3
[1.1.4]: https://github.com/hisaac/PlainPasta/compare/1.1.3...1.1.4
[1.1.5]: https://github.com/hisaac/PlainPasta/compare/1.1.4...1.1.5
[1.1.6]: https://github.com/hisaac/PlainPasta/compare/1.1.5...1.1.6
[1.2.0]: https://github.com/hisaac/PlainPasta/compare/1.1.6...1.2.0
[1.2.1]: https://github.com/hisaac/PlainPasta/compare/1.2.0...1.2.1
