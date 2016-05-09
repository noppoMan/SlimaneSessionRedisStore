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

    public init(loop: Loop, host: String = "127.0.0.1", port: UInt = 6379, expires: Int = (60 * 30), serializer: SerializerType = JsonSerializer()) throws {
        self.con = try Connection(loop: loop.loopPtr, host: host, port: port)
        self.serializer = serializer
    }

    // TODO need to change completion to GenericResult<[String : Any?]> -> ()
    public func load(_ sessionId: String, completion: (SessionResult<[String: AnyObject]>) -> Void) {
        Redis.command(self.con, command: .GET(sessionId)) { [unowned self] result in
            if case .Success(let repl) = result {
                guard let repl = repl as? String where repl != "" else {
                    return completion(.Data([:]))
                }
                
                do {
                    let dict = try self.serializer.deserialize(repl)
                    completion(.Data(dict))
                } catch {
                    completion(.Error(error))
                }
            }
        }
    }

    public func store(_ sessionId: String, values: [String: AnyObject], expires: Int?, completion: () -> Void) {
        do {
            let sesValue = try self.serializer.serialize(values)

            let command: Commands
            if let expires = expires {
                command = .SETEX(sessionId, expires, sesValue)
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
