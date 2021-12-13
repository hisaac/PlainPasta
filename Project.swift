import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let appTarget = Target(
    name: "Plain Pasta",
    platform: .macOS,
    product: .app,
    bundleId: "software.level.PlainPasta",
    deploymentTarget: .macOS(targetVersion: "11.0"),
    infoPlist: "PlainPasta/Sources/Info.plist",
    sources: "PlainPasta/Sources/**/*.swift",
    resources: "PlainPasta/Resources/**/*",
    entitlements: "PlainPasta/Sources/Plain Pasta.entitlements",
    scripts: [.pre(script: "export", name: "Log Build Settings")],
    dependencies: [
        .external(name: "Defaults"),
        .external(name: "Preferences"),
        .external(name: "PasteboardPublisher"),
        .external(name: "LSFoundation"),

        // This one has to be imported as a "real" SPM library, because it relies
        // on SPM's handling of its resource bundle.
        .package(product: "KeyboardShortcuts")
    ],
    settings: .settings(
        base: SettingsDictionary()
            .automaticCodeSigning(devTeam: "F2J52QJQ9Y")
            .codeSignIdentityAppleDevelopment()
            .currentProjectVersion("2.0.0")
            .appIconName("AppIcon")
    )
)

let testTarget = Target(
    name: "PlainPastaTests",
    platform: .macOS,
    product: .unitTests,
    bundleId: "software.level.PlainPasta.Tests",
    infoPlist: "PlainPasta/Tests/Info.plist",
    sources: "PlainPasta/Tests/**/*.swift",
    dependencies: [.target(name: "Plain Pasta")]
)

let plainPastaScheme = Scheme(
    name: "Plain Pasta",
    buildAction: .buildAction(targets: ["Plain Pasta"]),
    testAction: TestAction.targets(["PlainPastaTests"]),
    runAction: .runAction(
        preActions: [ExecutionAction(
            title: "Kill other open app instances",
            scriptText: #"echo $(pkill "Plain Pasta") > /dev/null"#
        )]
    )
)

let project = Project(
    name: "Plain Pasta",
    organizationName: "Isaac Halvorson",
    options: [.textSettings(usesTabs: true)],
    packages: [
        .remote(
            url: "https://github.com/sindresorhus/KeyboardShortcuts.git",
            requirement: .upToNextMajor(from: "1.3.0")
        )
    ],
    targets: [
        appTarget,
        testTarget
    ],
    schemes: [plainPastaScheme],
    fileHeaderTemplate: "",
    additionalFiles: [
        "README.md",
        "CHANGELOG.md",
        "LICENSE",
        "Assets/**/*",
        "ci_scripts/**/*",
        "docs/**/*",
        ".gitignore",
        ".swiftlint.yml"
    ]
)
