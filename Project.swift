import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

//let thing = Target(

let appTarget = Target(
    name: "PlainPasta",
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
            .appIconName("AppIcon")
            .automaticCodeSigning(devTeam: "F2J52QJQ9Y")
            .codeSignIdentityAppleDevelopment()
            .currentProjectVersion("2.0.0")
            .productName("Plain Pasta")
            .productModuleName("PlainPasta")
    )
)

let testTarget = Target(
    name: "PlainPastaTests",
    platform: .macOS,
    product: .unitTests,
    bundleId: "software.level.PlainPasta.Tests",
    infoPlist: "PlainPasta/Tests/Info.plist",
    sources: "PlainPasta/Tests/**/*.swift",
    dependencies: [.target(name: "PlainPasta")],
    settings: .settings(base: SettingsDictionary().automaticCodeSigning(devTeam: "F2J52QJQ9Y"))
)

let plainPastaScheme = Scheme(
    name: "PlainPasta",
    buildAction: .buildAction(
        targets: ["PlainPasta"],
        preActions: [ExecutionAction(
            title: "Kill other open app instances",
            scriptText: "echo $(pkill ${EXECUTABLE_NAME}) > /dev/null"
        )]
    ),
    testAction: .testPlans(["PlainPasta/Tests/PlainPastaTests.xctestplan"]),
    runAction: .runAction(configuration: "Debug", executable: "PlainPasta", diagnosticsOptions: [.mainThreadChecker]),
    archiveAction: .archiveAction(configuration: "Release", customArchiveName: "Plain Pasta"),
    profileAction: .profileAction(configuration: "Release", executable: "Plain Pasta"),
    analyzeAction: .analyzeAction(configuration: "Debug")
)

// TODO: Add pre-action for killing app

let project = Project(
    name: "PlainPasta",
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
        "Assets/**/*",
        "docs/**/*",
        ".gitignore",
        ".swiftlint.yml",
        ".tuist-version",
        "changelog.md",
        "LICENSE",
        "README.md"
    ]
)
