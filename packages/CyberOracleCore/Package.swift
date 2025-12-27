// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CyberOracleCore",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .macOS(.v14),
    ],
    products: [
        .library(name: "CyberOracleDomain", targets: ["CyberOracleDomain"]),
        .library(name: "CyberOracleData", targets: ["CyberOracleData"]),
    ],
    targets: [
        .target(
            name: "CyberOracleDomain",
            dependencies: []
        ),
        .target(
            name: "CyberOracleData",
            dependencies: ["CyberOracleDomain"],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "CyberOracleDataTests",
            dependencies: ["CyberOracleData"]
        ),
    ]
)

