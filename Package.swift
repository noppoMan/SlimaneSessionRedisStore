import PackageDescription

let package = Package(
    name: "SlimaneSessionRedisStore",
    dependencies: [
        .Package(url: "https://github.com/noppoMan/swift-redis.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/noppoMan/SlimaneMiddleware.git", majorVersion: 0, minor: 1)
    ]
)
