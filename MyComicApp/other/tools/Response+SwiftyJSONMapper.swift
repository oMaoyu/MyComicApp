//
//  Response+SwiftyJSONMapper.swift
//  securities
//
//  Created by 高子雄 on 2018/12/10.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

public extension Response {
    
    /// Maps data received from the signal into an object which implements the ALSwiftyJSONAble protocol.
    /// If the conversion fails, the signal errors.
    public func map<T: JSONMappable>(to type:T.Type) throws -> T {
        let jsonObject = try mapJSON()
        
        guard let mappedObject = T(fromJson: JSON(jsonObject)) else {
            throw MoyaError.jsonMapping(self)
        }
        
        return mappedObject
    }
    
    /// Maps data received from the signal into an array of objects which implement the ALSwiftyJSONAble protocol
    /// If the conversion fails, the signal errors.
    public func map<T: JSONMappable>(to type:[T.Type]) throws -> [T] {
        let jsonObject = try mapJSON()
        let mappedArray = JSON(jsonObject)
        let mappedObjectsArray = mappedArray.arrayValue.compactMap { T(fromJson: $0) }
        return mappedObjectsArray
    }
    
}

extension Response {
    
    @available(*, unavailable, renamed: "map(to:)")
    public func mapObject<T: JSONMappable>(type:T.Type) throws -> T {
        return try map(to: type)
    }
    
    @available(*, unavailable, renamed: "map(to:)")
    public func mapArray<T: JSONMappable>(type:T.Type) throws -> [T] {
        return try map(to: [type])
    }
}

