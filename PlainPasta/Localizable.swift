// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// About…
  internal static let about = L10n.tr("Localizable", "About…")
  /// Bundle
  internal static let bundle = L10n.tr("Localizable", "Bundle")
  /// Check for Updates…
  internal static let checkForUpdates = L10n.tr("Localizable", "Check for Updates…")
  /// Enabled
  internal static let enabled = L10n.tr("Localizable", "Enabled")
  /// Quit
  internal static let quit = L10n.tr("Localizable", "Quit")
  /// Version
  internal static let version = L10n.tr("Localizable", "Version")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
