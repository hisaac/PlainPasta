# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2020-09-07

### Changed

- Move to using GCD instead of `Timer` for repeat polling of the pasteboard. This provides a small increase in performance.
- Update entitlements file to allow for automatic creation of App ID in App Store Connect
- Remove "Check for Updates…" menu item, as this will now be done through the App Store
- Enable App Sandboxing for Mac App Store
- Enable hardened runtime
- Move Localizable.strings into Swift file

### Fixed

- Fixed a bug that would cause images on the pasteboard to be removed ([reported](https://github.com/hisaac/PlainPasta/issues/3) by [@foigus](https://github.com/foigus). Thanks!)

## [1.0.0] - 2018-11-04

Initial release! 🎉

[Unreleased]: https://github.com/hisaac/PlainPasta/compare/master...development
[1.0.0]: https://github.com/hisaac/PlainPasta/compare/3f3479bf1b417790735aa6cfb8850eb73fe74a07...1.0.0
[1.1.0]: https://github.com/hisaac/PlainPasta/compare/1.0.0...1.1.0
