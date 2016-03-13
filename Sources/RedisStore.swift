//
//  RedisStore.swift
//  SlimaneSessionRedisStore
//
//  Created by Yuki Takei on 3/12/16.
//  Copyright © 2016 MikeTOKYO. All rights reserved.
//

import Suv
import SlimaneMiddleware
import SwiftRedis
import Core
import Foundation

public class RedisStore: SessionStoreType {

    private let con: Connection
    
    private let serializer: SerializerType
    
    public init(loop: Loop, host: String = "127.0.0.1", port: UInt = 6379, expires: Int = (60 * 30), serializer: SerializerType = JsonSerializer()) throws {
        self.con = try Connection(loop: loop.loopPtr, host: host, port: port)
        self.serializer = serializer
    }
    
    // TODO need to change completion to GenericResult<[String : Any?]> -> ()
    public func reload(sessionId: String, completion: (SessionResult<[String: AnyObject?]>) -> Void) {
        SwiftRedis.command(self.con, command: .GET(sessionId)) { [unowned self] result in
            if case .Success(let repl) = result {
                if repl == "" {
                    completion(.None)
                } else {
                    do {
                        let dict = try self.serializer.deserialize(repl)
                        completion(.Data(dict))
                    } catch {
                        completion(.Error(error))
                    }
                }
            }
        }
    }
    
    public func store(sessionId: String, values: [String : AnyObject?], expires: Int?, completion: () -> Void) {
        var unwrapedValues: [String: AnyObject] = [:]
        for (key, value) in values {
            if let v = value {
                unwrapedValues[key] = v
            }
        }
        
        do {
            let sesValue = try self.serializer.serialize(unwrapedValues)
            
            let command: Commands
            if let expires = expires {
                command = .SETEX(sessionId, expires, sesValue)
            } else {
                command = .SET(sessionId, sesValue)
            }
            
            // Need to handle error
            SwiftRedis.command(con, command: command)
            completion()
        } catch {
            return completion()
        }
    }
    
    public func destroy(sessionId: String) {
        SwiftRedis.command(con, command: .DEL([sessionId]))
    }
}
