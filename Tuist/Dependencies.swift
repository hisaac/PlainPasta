import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(
            url: "https://github.com/sindresorhus/Defaults.git",
            requirement: .upToNextMajor(from: "6.1.0")
        ),
        .remote(
            url: "https://github.com/sindresorhus/Preferences.git",
            requirement: .upToNextMajor(from: "2.5.0")
        ),
        .remote(
            url: "https://github.com/hisaac/PasteboardPublisher.git",
            requirement: .branch("main")
        ),
        .remote(
            url: "https://github.com/hisaac/LSFoundation.git",
            requirement: .branch("main")
        )
    ],
    platforms: [.macOS]
)
