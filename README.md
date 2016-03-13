# SlimaneSessionRedisStore
Redis Store module for Slimane Session


## Usage

Pass the RedisStore Instance to SessionConfig.store

```swift
import SlimaneSessionRedisStore


let redisStore = try! RedisStore(loop: app.loop, host: "127.0.0.1", port: 6379)

let sesConfig = SessionConfig(
    secret: "secret",
    expires: 60 * 30,
    store: redisStore
)

app.use(SessionHandler(sesConfig))
```

## Package.json
```swift
import PackageDescription

let package = Package(
    name: "SlimaneSessionRedisStore",
    dependencies: [
        .Package(url: "https://github.com/noppoMan/SlimaneSessionRedisStore.git", majorVersion: 0, minor: 1)
    ]
)
```

## License

(The MIT License)

Copyright (c) 2016 Yuki Takei(Noppoman) yuki@miketokyo.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and marthis permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
