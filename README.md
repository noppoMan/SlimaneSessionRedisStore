# SessionRedisStore
Redis Store module for Slimane Session


## Usage

Pass the RedisStore Instance to SessionConfig.store

```swift
import SessionMiddleware
import SessionRedisStore

let redisStore = try! RedisStore(loop: app.loop, host: "127.0.0.1", port: 6379)

let sesConfig = SessionConfig(
    secret: "secret",
    expires: 60 * 30,
    store: redisStore
)

app.use(SessionMiddleware(conf: sesConfig))
```
## Package.json
```swift
import PackageDescription

let package = Package(
    name: "SessionRedisStore",
    dependencies: [
        .Package(url: "https://github.com/slimane-swift/SessionRedisStore.git", majorVersion: 0, minor: 1)
    ]
)
```

## License

SessionRedisStore is released under the MIT license. See LICENSE for details.
