//
//  PrimitiveSequence+SwiftyJSONMapper.swift
//  securities
//
//  Created by 高子雄 on 2018/12/10.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import RxSwift
/// Extension for processing Responses into Mappable objects through ObjectMapper
extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    /// Maps data received from the signal into an object which implements the ALSwiftyJSONAble protocol.
    /// If the conversion fails, the signal errors.
    public func map<T: JSONMappable>(to type: T.Type) -> Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(try response.map(to: type))
        }
    }
    
    /// Maps data received from the signal into an array of objects which implement the ALSwiftyJSONAble protocol.
    /// If the conversion fails, the signal errors.
    public func map<T: JSONMappable>(to type: [T.Type]) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.map(to: type))
        }
    }
}
