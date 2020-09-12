# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

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
