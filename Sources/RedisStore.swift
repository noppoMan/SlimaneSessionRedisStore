//
//  RedisStore.swift
//  SlimaneSessionRedisStore
//
//  Created by Yuki Takei on 3/12/16.
//  Copyright © 2016 MikeTOKYO. All rights reserved.
//

@_exported import SwiftRedis
@_exported import SessionMiddleware

public class RedisStore: SessionStoreType {

    private let con: SwiftRedis.Connection

    private let serializer: SerializerType

    public init(loop: Loop, host: String = "127.0.0.1", port: UInt = 6379, expires: Int = (60 * 30), serializer: SerializerType = DefaultSerializer()) throws {
        self.con = try Connection(loop: loop.loopPtr, host: host, port: port)
        self.serializer = serializer
    }

    public func load(_ sessionId: String, completion: @escaping ((Void) throws -> [String: String]) -> Void) {
        Redis.command(self.con, command: .GET(sessionId)) { [unowned self] result in
            if case .success(let repl) = result {
                guard let repl = repl as? String , !repl.isEmpty else {
                    return completion { [:] }
                }
                
                completion {
                    try self.serializer.deserialize(repl)
                }
            }
        }
    }

    public func store(_ sessionId: String, values: [String: String], expiration: Int?, completion: @escaping () -> Void) {
        do {
            let sesValue = try self.serializer.serialize(values)

            let command: Commands
            if let expiration = expiration {
                command = .SETEX(sessionId, expiration, sesValue)
            } else {
                command = .SET(sessionId, sesValue)
            }

            // Need to handle error
            Redis.command(con, command: command)
            completion()
        } catch {
            return completion()
        }
    }

    public func destroy(_ sessionId: String) {
        Redis.command(con, command: .DEL([sessionId]))
    }
}
